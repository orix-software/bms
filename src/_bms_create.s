.include "telestrat.inc"

.export _bms_create

.import bms_create

.import popax

.importzp tmp1

; void *bms_create(size_t length, unsigned char flags);
.proc _bms_create

    ; This is a placeholder for bms_create function.
    ; It should be implemented to create a memory mapping.
    ; A contains flags
    flags := tmp1
    ; Save flags
    sta     flags

    ; Get length
    jsr     popax

    tay
    lda     flags
    jmp     bms_create


.endproc
