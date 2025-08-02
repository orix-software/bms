
.include "telestrat.inc"
.include "bms.inc"

.include "SDK_memory.mac"
.include "SDK_print.mac"
.include "SDK_conio.mac"

.export bms_create
.export bms_error_var

.import bms_bank_save_state
.import bms_bank_restore_state

.proc bms_create
    ;;@brief create slot for bank memory system. Returns NULL and store error, if something is wrong, or returns struct ptr if success
    ;;@inputA flags (eg : FLAG_PROT_READ_WRITE only supported)
    ;;@inputY low byte of the length to allocate (0 to 7)
    ;;@inputX high byte of the length to allocate (8 to 15)
    ;;@inputMEM_RES 2 byte of the length to allocate (16 to 23)
    ;;@modifyMEM_RES
    ;;@modifyMEM_TR2
    ;;@modifyMEM_libzp
    ;;@modifyMEM_libzp+2
    ;;@modifyMEM_libzp+4
    ;;@modifyMEM_libzp+5
    ;;@returnsA contains the bank number found
    ;;@note Use "BMS_CREATE length0_to_15, length16_to_31, flags" macro in 'include/bms.mac'


    bms_flags  := TR2  ; One byte
    bms_length := libzp  ; 2 bytes others bytes are in RES
    bms_ptr    := libzp + 2 ; 2 bytes
    bms_tmp1   := libzp + 4
    bms_tmp2   := libzp + 5
    bms_tmp3   := libzp + 6
    bms_tmp4   := libzp + 7

    sta     bms_length     ; Store the length in the library zero page (low adress length)
    stx     bms_length + 1 ; Store the length in the library zero page (High address length)
    sty     bms_flags      ; Store the flags in the library zero page


    ; Test if length is less than 16 bits
    lda     RES + 1
    bne     @returnNULL_length_too_long

@continue:
    lda     RES
    bne     @returnNULL_length_too_long

@continue_15_to_0:
    ; test if we run into a bank
    lda     bms_create
    cmp     #>$c000
    bcc     @not_into_bank
    lda     #BMS_CAN_NOT_RUN_INTO_BANK
    sta     bms_error_var ; Store the error code in the bms_error_var
    lda     #$00
    ldx     #$00
    rts

@returnNULL_length_too_long:

    lda     #BMS_LENGTH_REQUESTED_TOO_LONG
    sta     bms_error_var ; Store the error code in the bms_error_var
    lda     #$00
    tax
    rts

@not_into_bank:
    ; Test if greater than one bank (temporary (FIXME))
    lda     bms_length + 1
    cmp     #>BMS_MAX_SIZE_PER_BANK
    bcs     @returnNULL_length_too_long

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

    ; Set the length in struct

    ldy     #bms_struct::length
    lda     bms_length ; Load the low byte of the length
    sta     (bms_ptr),y ; Store the low byte of the length in the
    iny
    lda     bms_length + 1 ; Load the high byte of the length
    sta     (bms_ptr),y ; Store the high byte of the length in the bms_struct structure

    ; Initialize the bms_struct structure
    ldy     #bms_struct::number_of_banks
    lda     #$00        ; Initialize the number of banks to 0
    sta     (bms_ptr),y ; Store the number of banks in the bms_struct structure

    ; Store version into struct
    ldx     #$00 ; X is the index for the version string#
    ldy     #bms_struct::version ; $321 register
@L1:
    lda     BMS_VERSION,x
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

    lda     bms_length + 1 ; Load the low byte of the length
    beq     @exit


@substract:
    lda     bms_length + 1 ; Load the high byte of the length
    sec
    sbc     #>BMS_MAX_SIZE_PER_BANK     ; Compare it with BMS_MAX_SIZE_PER_BANK
    bcs     @is_greater ;

    ; Allocate last bank
    jsr     @allocate_bank ; Get the length from the stack
    cmp     #$00           ; Check if the allocation was successful
    beq     @error_no_bank_available

@exit:

    ; Init fp to 0
    lda     #$00
    ldy     #bms_struct::fp_offset
    sta     (bms_ptr),y
    iny
    sta     (bms_ptr),y

    ; And set current set and bank
    ldy     #bms_struct::bank_register
    lda     (bms_ptr),y
    ldy     #bms_struct::current_bank_register
    sta     (bms_ptr),y

    ldy     #bms_struct::current_set
    lda     (bms_ptr),y
    ldy     #bms_struct::current_set
    sta     (bms_ptr),y

    lda     #BMS_EOK
    sta     bms_error_var ; Store the error code in the bms_error_var

    lda     bms_ptr     ; Load the pointer to the allocated memory
    ldx     bms_ptr + 1 ; Load the pointer to the allocated memory (high byte)
    rts

@error_no_bank_available:
    mfree (bms_ptr) ; Free the allocated memory
    lda     #BMS_EBANK_FULL
    lda     #$00     ; Return null
    tax
    rts


@is_greater:
    sta     bms_length + 1 ; Store the high byte of the length

    jsr     @allocate_bank ; Get the length from the stack
    cmp     #$00           ; Check if the allocation was successful
    beq     @error_no_bank_available

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
    cmp     #$00 ; Out of Bank
    bne     @not_oob

    rts

@not_oob:
    ; A bank id
    ; X set
    ; Y the $321 register
    sty     bms_tmp1

    ; Get the current bank id
    pha
    ldy     #bms_struct::number_of_banks
    lda     (bms_ptr),y
    sta     bms_tmp2

    ; Compute
    lda     #bms_struct::bankid ; Y is the offset of the bank id in the bms_struct structure
    clc
    adc     bms_tmp2 ; Add the number of banks to the bank id
    tay
    ; and store
    pla
    sta     (bms_ptr),y ; Store the bank id in the bms_struct structure


    lda     #bms_struct::set ; Y is the offset of the bank id in the bms_struct structure
    clc
    adc     bms_tmp2 ; Add the number of banks to the bank id
    tay
    txa
    sta     (bms_ptr),y ; Store the bank id in the bms_struct structure


    lda     #bms_struct::bank_register  ; Y is the offset of the bank id in the bms_struct structure
    clc
    adc     bms_tmp2 ; Add the number of banks to the bank id
    tay

    lda     bms_tmp1 ; Load the bank id from the RES register
    sta     (bms_ptr),y ; Store the bank id in the bms_struct structure

    ; store the signature

    jsr     bms_bank_save_state

    sta     $321

    lda     $342
    ora     #%00100000 ; Set the bank as writable
    sta     $342 ; Store the writable flag in the bank register

    ldy     #bms_struct::set ; Y is the offset of the bank id in the bms_struct structure
    lda     (bms_ptr),y
    sta     $343


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
    jsr     bms_bank_restore_state

    ; Compute boundaries

    ldy     #bms_struct::number_of_banks
    lda     (bms_ptr),y
    sta     bms_tmp2
    bne     @not_slot_0

    ; First slot is special, it is the slot 0
    ; Set low boundaries to 0
    lda     #$00
    ldy     #bms_struct::lboundaries
    sta     (bms_ptr),y
    iny
    sta     (bms_ptr),y

.ifdef BMS_EXTENDED
    iny
    sta     (bms_ptr),y
    iny
    sta     (bms_ptr),y
.endif

    ; Set high boundaries to BMS_MAX_SIZE_PER_BANK
    ldy     #bms_struct::hboundaries+1
    lda     #>BMS_MAX_SIZE_PER_BANK
    sta     (bms_ptr),y
    sta     bms_tmp4 ; Store the number of banks in bms_tmp1

    dey

    lda     #<BMS_MAX_SIZE_PER_BANK
    sta     (bms_ptr),y
    clc
    adc     #$01
    bcc     @no_inc
    inc     bms_tmp4
    ; If the addition overflowed, we need to increment the high boundary
@no_inc:
    sta     bms_tmp3 ; Store the number of banks in bms_tmp1

    jmp     @inc_number_of_banks ; Could be  bne but it could generate a bug if >BMS_MAX_SIZE_PER_BANK is = $00

.ifdef BMS_EXTENDED
    lda     #$00 ; Set the boundaries to 0
    iny
    sta     (bms_ptr),y
    iny
    sta     (bms_ptr),y
    beq     @inc_number_of_banks
.endif


@not_slot_0:

    lda     bms_tmp2
    asl
    clc
    adc     #bms_struct::lboundaries + 1 ; Add the number of banks to the lboundaries offset
    tay

    lda     bms_tmp4
    sta     (bms_ptr),y
    clc
    adc     #>BMS_MAX_SIZE_PER_BANK ; Add the high byte of BMS_MAX_SIZE_PER_BANK
    sta     bms_tmp4

    lda     bms_tmp3
    dey
    sta     (bms_ptr),y
    clc
    adc     #<BMS_MAX_SIZE_PER_BANK ; Add the high byte of BMS_MAX_SIZE_PER_BANK
    sta     bms_tmp3
    bcc     @no_inc2
    inc     bms_tmp4 ; If the addition overflowed, we need to increment the high boundary

@no_inc2:


    lda     bms_tmp2
    asl
    clc
    adc     #bms_struct::hboundaries + 1 ; Add the number of banks to the lboundaries offset
    tay
    lda     bms_tmp4
    sta     (bms_ptr),y

    dey
    lda     bms_tmp3
    sta     (bms_ptr),y




.ifdef BMS_EXTENDED
    ; 16
    dey
    lda     (bms_ptr),y
    tax
    iny
    sta     (bms_ptr),y
    ; 24
    dey
    lda     (bms_ptr),y
    tax
    iny
    sta     (bms_ptr),y
.endif




@inc_number_of_banks:
    ; Inc number_of_bankds
    ldy     #bms_struct::number_of_banks
    lda     (bms_ptr),y
    tax
    inx
    txa
    sta     (bms_ptr),y


    lda     #$01 ; Success
    rts

bms_str:
    .asciiz "Bms usage"
.endproc

bms_error_var:
    .byte 0
