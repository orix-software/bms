
.include "telestrat.inc"
.include "bms.inc"

.include "SDK_memory.mac"
.include "SDK_print.mac"
.include "SDK_conio.mac"

.export bms_create


;  void *memory_segment = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);

;     if (memory_segment == MAP_FAILED) {
;         perror("mmap");
;         exit(EXIT_FAILURE);
;     }


;         .res $FFF0-*
;         .org $FFF0
; ; $fff0
; ; $00 : empty ROM
; ; $01 : command ROM
; ; $02 : TMPFS
; ; $03 : Drivers
; ; $04 : filesystem drivers
; type_of_rom:
; .byt $00
; ; $fff1
; parse_vector:
;         .byt $00,$00
; ; fff3
; adress_commands:
;         .addr commands_address
; ; fff5
; list_commands:
;         .addr command1_str
; ; $fff7
; number_of_commands:
;         .byt 0
; signature_address:
;         .word   rom_signature

; ; ----------------------------------------------------------------------------
; ; Version + ROM Type
; ROMDEF:
;         .addr rom_start

; ; ----------------------------------------------------------------------------
; ; RESET
; rom_reset:
;         .addr   rom_start
; ; ----------------------------------------------------------------------------
; ; IRQ Vector
; empty_rom_irq_vector:
;         .addr   IRQVECTOR ; from telestrat.inc (cc65)


.proc bms_create

    bms_flags  := TR2  ; One byte
    bms_length := libzp  ; 2 bytes
    bms_ptr    := libzp + 2 ; 2 bytes


    sta     bms_flags      ; Store the flags in the library zero page
    sty     bms_length     ; Store the length in the library zero page (low adress length)
    stx     bms_length + 1 ; Store the length in the library zero page (High address length)

    ; A and Y : size to allocate
    ; A flags
    ; X (low) and Y (high) : length
    ; Malloc uses TR7 only
    malloc #.sizeof(bms_struct) ; Allocate memory for the bms_struct structure

    cmp     #$00
    bne     @not_null
    cpy     #$00
    bne     @not_null
    ldx     #$00
    ; return null (X is for C)
    rts

@not_null:
    sta     bms_ptr     ; Store the pointer to the allocated memory in tmp_ptr
    sty     bms_ptr + 1 ; Store the pointer to the allocated memory in tmp_ptr+1

    ; Initialize the bms_struct structure
    ldy     #bms_struct::number_of_banks
    lda     #$00        ; Initialize the number of banks to 0
    sta     (bms_ptr),y ; Store the number of banks in the bms_struct structure

    ; Store version into struct
    ldx     #$00 ; X is the index for the version string#
    ldy     #bms_struct::version ; $321 register
@L1:
    lda     MAPO_VERSION,x
    beq     @out
    sta     (bms_ptr),y
    iny
    inx
    bne     @L1
    lda     #$00 ; Null-terminate the string
    ;   ; Store the null terminator in the version string
@out:
    sta     (bms_ptr),y

@L2:

    ; crlf
    ; nop
    ; lda     bms_length
    ; ldy     bms_length + 1
    ; print_int ,3,2
    ; crlf

    lda     bms_length ; Load the low byte of the length
    bne     @substract

    lda     bms_length+1 ; Load the low byte of the length
    beq     @exit


@substract:
    lda     bms_length + 1 ; Load the high byte of the length
    sec
    sbc     #>BMS_MAX_SIZE_PER_BANK     ; Compare it with BMS_MAX_SIZE_PER_BANK
    bcs     @is_greater ;

    ; Allocate last bank
    jsr     @allocate_bank ; Get the length from the stack


@exit:
    lda     bms_ptr     ; Load the pointer to the allocated memory
    ldx     bms_ptr + 1 ; Load the pointer to the allocated memory (high byte)
    rts


@is_greater:
    sta     bms_length + 1 ; Store the high byte of the length

    jsr     @allocate_bank ; Get the length from the stack

    lda     bms_length ; Load the low byte of the length
    sec
    sbc     #<BMS_MAX_SIZE_PER_BANK     ; Compare it with BMS_MAX_SIZE_PER_BANK
    bcs     @is_greater_low

    lda     #$00
    sta     bms_length

@is_greater_low:
    sta     bms_length ; Store the low byte of the length

    lda     bms_length + 1 ; Load the high byte of the length
    beq     @no_decrement ; If the high byte is zero, do not decrement
    lda     bms_length + 1
    sbc     #$00
    sta     bms_length + 1

@no_decrement:

    jmp     @L2 ; Loop to allocate banks until the length is reached


@allocate_bank:
    lda     #KERNEL_ALLOCATE_BANK    ; Mode : allocate bank
    ldx     #KERNEL_RAM_BANK_APPLICATION_TYPE ; X the type of bank (persistant bank)
    BRK_TELEMON XBANK ; GET free bank, Use RES
    ; A bank id
    ; X set
    ; Y the $321 register
    sty     RES

    ldy     #bms_struct::bankid ; Y is the offset of the bank id in the bms_struct structure
    sta     (bms_ptr),y ; Store the bank id in the bms_struct structure

    txa
    ldy     #bms_struct::set ; Y is the offset of the bank id in the bms_struct structure
    sta     (bms_ptr),y ; Store the bank id in the bms_struct structure

    ldy     #bms_struct::number_of_banks
    lda     (bms_ptr),y
    tax
    inx
    txa
    sta     (bms_ptr),y

    ldy     #bms_struct::bank_register ; Y is the offset of the bank id in the bms_struct structure
    lda     RES ; Load the bank id from the RES register
    sta     (bms_ptr),y ; Store the bank id in the bms_struct structure

    ; store the signature
    sei
    ; Save
    ldx     $321
    stx     RESB

    ldx     $343
    stx     RESB + 1

    ldx     $342
    stx     TR0

    sta     $321

    lda     $342
    ora     #%00100000 ; Set the bank as writable
    sta     $342 ; Store the writable flag in the bank register

    ldy     #bms_struct::set ; Y is the offset of the bank id in the bms_struct structure
    lda     (bms_ptr),y
    sta     $343

   ; ldy     #bms_struct::bankid ; Y is the offset of the bank id in the bms_struct structure
    ;lda     (bms_ptr),y ; Store the bank id in the bms_struct structure1

    lda     #$02
    sta     $fff0

    lda     #<($c000 + BMS_MAX_SIZE_PER_BANK)
    sta     $fff8
    lda     #>($c000 + BMS_MAX_SIZE_PER_BANK)
    sta     $fff9

    ldx     #$00

@L3:
    lda     bms_str,x
    sta     $c000 + BMS_MAX_SIZE_PER_BANK,x
    beq     @done
    inx
    bne     @L3

@done:
    ldx     RESB
    stx     $321

    ldx     RESB + 1
    stx     $343

    ldx     TR0
    stx     $342

    cli

    rts

bms_str:
    .asciiz "Bms"


.endproc
