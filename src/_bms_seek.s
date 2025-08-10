.export _bms_seek

.include "telestrat.inc"

.import bms_seek

.import popax

.importzp tmp0

; unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);

.proc _bms_seek
    ;;@proto unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);
    ;;@brief seek to offset
    ;;@param bms (bms *) bms struct
    ;;@param offset (unsigned int)  data
    ;;@param whence (unsigned char)
    ;;@returns (unsigned int) result
    sta     tmp0         ; Save A

    jsr     popax
    sta     TR0
    stx     TR1

    jsr     popax

    ; Send A & X

    ldy     tmp0
    jmp     bms_seek
.endproc
