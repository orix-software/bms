.export _bms_read_write

.import bms_read_write

.include "telestrat.inc"
.include "bms.inc"

.import popax, popa

.importzp tmp1


.proc _bms_read_write
    ;;@proto unsigned int bms_read_write(bms *bms, unsigned int length, void *data, unsigned char mode);
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
    mode   := tmp1
    data   := TR0 ; word
    length := TR2 ; word

    sta     mode

    jsr     popax
    sta     data      ; Data (TR0)
    stx     data + 1  ; Data (TR1)

    ; Length
    jsr     popax
    sta     length
    stx     length + 1

    ; bms struct
    jsr     popax


    ldy     mode
    jmp     bms_read_write

.endproc
