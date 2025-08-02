.export _bms_read

.import bms_write

.include "telestrat.inc"
.include "bms.inc"

.import popax

.proc _bms_read
    ;;@proto unsigned int bms_write(bms *bms, unsigned int length, void *data);
    ; A & X contains the ptr to the bms structure
    ; RES := offset 
    ; RESB := offset 32
    ; TR0 & TR1 := ptr data
    ; TR2 & TR3 := size

    sta     TR0 ; Data
    stx     TR1 ; Data

    ; Length
    jsr     popax
    sta     TR2
    stx     TR3

    ; bms struct
    jsr     popax
    sta     RES
    stx     RES + 1

    ldy     #READ_MODE
    jmp     bms_write

.endproc
