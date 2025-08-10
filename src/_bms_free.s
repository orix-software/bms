.export _bms_free

.include "telestrat.inc"
.include "bms.inc"
.export _bms_free

.import bms_free

.proc _bms_free
    ;;@proto unsigned char bms_free(bms *bms);
    ;;@param bms (bms *) bms struct
    ; A & X contains the ptr to the bms structure
    jmp     bms_free
.endproc
