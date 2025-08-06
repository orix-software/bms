.export bms_free

.include "telestrat.inc"
.include "bms.inc"

.include "SDK_memory.mac"

.import bms_bank_save_state
.import bms_bank_restore_state

.proc bms_free
    ;;@brief Free bms struct and liberate banks
    ;;@inputA low byte of the bms struct pointer
    ;;@inputX high byte of the bms struct pointer
    ;;@modifyMEM_libzp
    ;;@modifyMEM_libzp+2
    ;;@modifyMEM_libzp+4
    ;;@modifyMEM_libzp+5
    ;;@```asm
    ;;@` lda bms_ptr
    ;;@` ldx bms_ptr + 1
    ;;@` jsr bms_free
    ;;@```
    ;;@explain Here

    bms_ptr  := libzp ; 2 bytes
    bms_tmp1 := libzp + 2 ; 1 byte
    bms_tmp2 := libzp + 3 ; 1 byte
    bms_tmp3 := libzp + 4 ; 1 byte

    ; A and X contains the ptr to the bms structure
    sta     bms_ptr
    stx     bms_ptr + 1

    ; Get the number of bank
    ldy     #bms_struct::number_of_banks ; A is the offset of the number of banks in the bms_struct structure
    lda     (bms_ptr),y
    sta     bms_tmp2 ; Store the number of banks in bms_tmp1

    lda     #$00 ; Initialize the bank id to 0
    sta     bms_tmp3 ; Store the bank id in bms_tmp1

@loop:
    lda     #bms_struct::bankid ; Y is the offset of the bank id in the bms_struct structure
    clc
    adc     bms_tmp3
    tay

    lda     (bms_ptr),y ; Load the bank id from the bms_struct structure
    tax

    lda     #KERNEL_FREE_BANK    ; Mode : allocate bank
    BRK_TELEMON XBANK            ; Call free bank

    lda     #bms_struct::bank_register
    clc
    adc     bms_tmp3
    tay
    lda     (bms_ptr),y


    jsr     clear_bank

    inc     bms_tmp3
    dec     bms_tmp2
    bne     @loop

    lda     #$00
    rts

clear_bank:
    jsr     bms_bank_save_state
    sta     $321

    lda     $342
    ora     #%00100000 ; Set the bank as writable
    sta     $342 ; Store the writable flag in the bank register

    ldy     #bms_struct::set ; Y is the offset of the bank id in the bms_struct structure
    lda     (bms_ptr),y
    sta     $343

    lda     #$00
    sta     $fff0


    ldx     #$00

@L3:
    lda     @bms_str_free,x
    sta     $c000 + BMS_MAX_SIZE_PER_BANK,x
    beq     @done
    inx
    bne     @L3

@done:

    jsr     bms_bank_restore_state
    rts

@bms_str_free:
    .asciiz "Free"

.endproc
