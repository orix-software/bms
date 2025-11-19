.export _bms_seek

.include "telestrat.inc"

.import bms_seek

.import popax

.importzp tmp1

; unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);

.proc _bms_seek
    ;;@proto unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);
    ;;@brief seek to offset
    ;;@param bms (bms *) bms struct
    ;;@param offset (unsigned int)  data
    ;;@param whence (unsigned char) (possible value : BMS_SEEK_CUR, BMS_SEEK_SET, not managed : BMS_SEEK_END,)

    ;;@returns (unsigned int) result
    sta     tmp1         ; Save whence

    jsr     popax
    sta     TR0
    stx     TR1

    jsr     popax

    ; Send A & X

    ldy     tmp1
    jmp     bms_seek
.endproc
