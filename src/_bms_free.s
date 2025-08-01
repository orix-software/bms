.export _bms_free

.include "telestrat.inc"
.include "bms.inc"
.export _bms_free

.import bms_free

; unsigned char bms_free(bms *bms);
.proc _bms_free
    ; A & X contains the ptr to the bms structure
    jmp     bms_free
.endproc
