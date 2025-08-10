.export bms_seek

.define SEEK_CUR        0
.define SEEK_END        1
.define SEEK_SET        2

.include "bms.inc"
.include "telestrat.inc"
.include "errno.inc"

.proc bms_seek
    ;;@brief Seek in the bms offset
    ;;@inputA low byte of the bms struct pointer
    ;;@inputX high byte of the bms struct pointer
    ;;@inputY whence
    ;;@inputTR0 low byte of the offset to seek
    ;;@inputTR1 high byte of the offset to seek
    ;;@modifyMEM_libzp

    ;;@```asm
    ;;@` lda #<5 ; Offset low
    ;;@` sta TR0 ; Offset low
    ;;@` lda #>5 ; Offset high
    ;;@` sta TR1 ; Offset high
    ;;@` lda bms_ptr ; Offset High of bms struct
    ;;@` ldx bms_ptr + 1; Offset High of bms struct
    ;;@` ldy #BMS_SEEK_CUR
    ;;@` jsr bms_seek
    ;;@` jsr rts
    ;;@```


    ; A & X contains the ptr to the bms structure
    ; TR0 & TR1 contains the offset
    ; Y the whence
    bms_ptr         := RES
    tmp16           := libzp

    sta     bms_ptr
    stx     bms_ptr + 1

    cpy     #SEEK_CUR
    beq     @seek_cur
    cpy     #SEEK_END
    beq     @seek_end
    cpy     #SEEK_SET
    beq     @seek_set
    ; Invalid whence
    lda     #EINVAL
    rts

@seek_set:
    ldy     #bms_struct::fp_offset
    lda     TR0
    sta     (bms_ptr),y
    iny
    lda     TR1
    sta     (bms_ptr),y
    rts

@seek_cur:
    ldy     #bms_struct::fp_offset
    lda     TR0
    clc
    adc     (bms_ptr),y
    sta     (bms_ptr),y
    iny
    lda     TR1
    adc     (bms_ptr),y
    sta     (bms_ptr),y
    rts


@seek_end:
    ldy     #bms_struct::length
    lda     (bms_ptr),y
    clc
    ldy     #bms_struct::fp_offset
    adc     (bms_ptr),y
    sta     (bms_ptr),y

    ldy     #bms_struct::length + 1
    lda     (bms_ptr),y
    ldy     #bms_struct::fp_offset + 1
    adc     (bms_ptr),y
    sta     (bms_ptr),y

    rts


.endproc

