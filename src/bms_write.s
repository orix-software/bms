.include "telestrat.inc"
.include "bms.inc"

.export bms_write

.import bms_bank_save_state
.import bms_bank_restore_state

; bms_put(bms_instance, 5, str_hello);
.proc bms_write
    ; A & X contains the ptr to the bms structure
    ; Y is the mode
    ; RES := ptr struct

    ; TR0 & TR1 := ptr data
    ; TR2 & TR3 := size


    bms_ptr                          := libzp      ; 2 bytes
    bms_data_ptr                     := libzp + 2  ; 2 bytes
    length_to_write                  := libzp + 4  ; 2 bytes
    mode                             := libzp + 6  ; 1 byte
    bms_ptr_for_switch               := libzp + 7  ; 2 byte
    high_offset                      := libzp + 9  ; One byte
    current_bank_to_check            := libzp + 10 ; One byte
    number_of_bank_to_check          := libzp + 11 ; One byte
    number_of_bytes_to_r_w_last_bank := libzp + 12 ; two bytes
    virtual_offset                   := libzp + 14 ; two byte


    sta     bms_ptr
    stx     bms_ptr + 1
    sty     mode

    lda     TR2
    sta     length_to_write

    lda     TR3
    sta     length_to_write + 1

    lda     TR0 ; Data pointer

    sta     bms_data_ptr

    lda     TR1
    sta     bms_data_ptr + 1

    ; Compute set and bank

    jsr     bms_compute_bank_set

    ; Set the offset
    lda     virtual_offset + 1
    clc
    adc     #>$c000
    sta     bms_ptr_for_switch + 1

    lda     virtual_offset
    clc
    adc     #<$c000
    sta     bms_ptr_for_switch


    jsr     bms_bank_save_state

    ldy     #bms_struct::current_bank_register ; Y is the offset of the bank id in the bms_struct structure
    lda     (bms_ptr),y

    sta     $321

    lda     $342
    ora     #%00100000 ; Set the bank as writable
    sta     $342 ; Store the writable flag in the bank register

    ldy     #bms_struct::current_set ; Y is the offset of the bank id in the bms_struct structure
    lda     (bms_ptr),y
    sta     $343

@L2:
    ldy     #$00

    lda     mode
    beq     @write


    ldy     #$00
@loop_read:
    lda     (bms_ptr_for_switch),y
    sta     (bms_data_ptr),y
    iny
    cpy     length_to_write
    bne     @loop_read
    beq     @compute


@write:

@L1:
    lda     (bms_data_ptr),y
    sta     (bms_ptr_for_switch),y
    iny
    cpy     length_to_write
    bne     @L1


@compute:
    tya
    clc
    adc     bms_ptr_for_switch
    bcc     @no_inc
    inc     bms_ptr_for_switch + 1
@no_inc:
    sta     bms_ptr_for_switch

    ldy     #bms_struct::fp_offset
    lda     (bms_ptr),y
    clc
    adc     length_to_write
    sta     (bms_ptr),y
    bcc     @no_inc_fp_offset
    iny
    lda     (bms_ptr),y
    tay
    iny
    sta     (bms_ptr),y


@no_inc_fp_offset:

    lda     length_to_write + 1
    beq     @exit

    dec     length_to_write + 1
    bne     @L2

@exit:
    ; Restore the bank register
    ldy     #bms_struct::current_bank_register
    lda     (bms_ptr),y
    sta     $321

    ; Restore the writable flag
    lda     $342
    and     #%11011111 ; Clear the writable flag
    sta     $342

    ; Restore the current set
    ldy     #bms_struct::current_set
    lda     (bms_ptr),y
    sta     $343

@done:
    jsr     bms_bank_restore_state

    rts

bms_compute_bank_set:
    ;;@brief compute bank and set depending of the offset (bms_ptr must be set), and set current bank set
    ;;@modifyMEM_RESB
    ;;@modifyMEM_TR0
    ;;@modifyMEM_libzp
    ;;@modifyMEM_libzp+9



    lda     #$00 ; First slot (bank)
    sta     current_bank_to_check

    ; ldy     #bms_struct::fp_offset + 1 ; High
    ; lda     (bms_ptr),y ; Get High offset
    ; sta     virtual_offset + 1 ; store high voffset

    ldy     #bms_struct::fp_offset ; High
    lda     (bms_ptr),y ; Get High offset
    sta     virtual_offset ; store high voffset

@L1:
    ldy     #bms_struct::fp_offset + 1 ; High
    lda     (bms_ptr),y ; Get High offset
    sta     virtual_offset + 1 ; store high voffset
    sta     high_offset ; and store

    lda     #bms_struct::hboundaries ; get high boundary first slot
    clc
    adc     current_bank_to_check
    tay
    lda     (bms_ptr),y  ; Get High boundary
    cmp     high_offset
    bcc     @found_bank ; If high_offset is less than the high boundary, we found the bank
    beq     @found_bank
    ; Not found, check next bank (increment current_bank_to_check)
    lda     virtual_offset + 1
    sec
    sbc     #>BMS_MAX_SIZE_PER_BANK
    sta     virtual_offset + 1 ; store high voffset
    inc     current_bank_to_check
    bne     @L1


@found_bank:
    ldy     #bms_struct::fp_offset ; low
    lda     (bms_ptr),y ; Get Low offset
  ;  sta     virtual_offset + 1 ; store low voffset
    beq     @exit
    inc     current_bank_to_check

@exit:
    lda     #bms_struct::set
    clc
    adc     current_bank_to_check
    tay
    lda     (bms_ptr),y ; get set
    ldy     #bms_struct::current_set
    sta     (bms_ptr),y


    lda     #bms_struct::bank_register
    clc
    adc     current_bank_to_check
    tay
    lda     (bms_ptr),y ; get set
    ldy     #bms_struct::current_bank_register
    sta     (bms_ptr),y

    ldx     #$00
    ; Compute number of  bank to parse
    ldy     #bms_struct::fp_offset + 1 ; High
    lda     (bms_ptr),y ; Get High offset
@L4:
    cmp     #>BMS_MAX_SIZE_PER_BANK
    bcc     @no_others_bank
    ; greater
    sec
    sbc     #>BMS_MAX_SIZE_PER_BANK
    inx
    jmp     @L4

@no_others_bank:
    sta     number_of_bytes_to_r_w_last_bank + 1
    ldy     #bms_struct::fp_offset
    lda     (bms_ptr),y ; Get High offset
    sta     number_of_bytes_to_r_w_last_bank
    stx     number_of_bank_to_check

    rts

.endproc

