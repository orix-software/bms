.export bms_bank_save_state
.include "telestrat.inc"

.proc bms_bank_save_state
    ;;@brief save the state of the bank
    ;;@modifyMEM_RESB
    ;;@modifyMEM_TR0

    sei
    ; Save
    ldx     $321
    stx     RESB

    ldx     $343
    stx     RESB + 1

    ldx     $342
    stx     TR0

    rts
.endproc
