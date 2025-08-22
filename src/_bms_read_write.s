.export _bms_read_write

.import bms_read_write

.include "telestrat.inc"
.include "bms.inc"

.import popax, popa

.import tmp1

.proc _bms_read_write
    ;;@proto unsigned int bms_write(bms *bms, unsigned int length, void *data);
    ;;@brief read or write data
    ;;@param bms (bms *) bms struct
    ;;@param data (void *) data
    ;;@param length (void *) length to put or to get
    ;;@returns (unsigned int) number of bytes read or written
    ; A & X contains the ptr to the bms structure
    ; RES := offset 
    ; RESB := offset 32
    ; TR0 & TR1 := ptr data
    ; TR2 & TR3 := size
    jsr     popa
    sta     tmp1


    jsr     popax
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

    ldy     tmp1


    jmp     bms_read_write

.endproc
