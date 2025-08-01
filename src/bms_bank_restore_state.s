.export bms_bank_restore_state
.include "telestrat.inc"

.proc bms_bank_restore_state
    ;;@brief restore the state of the bank
    ;;@modifyMEM_RESB
    ;;@modifyMEM_TR0

    ldx     RESB
    stx     $321

    ldx     RESB + 1
    stx     $343

    ldx     TR0
    stx     $342

    cli
    rts
.endproc
