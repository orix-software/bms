.include "telestrat.inc"

.export _bms_create

.import bms_create

.import popax

.importzp tmp1, ptr1

; void *bms_create(size_t length, unsigned char flags);
.proc _bms_create

    ; This is a placeholder for bms_create function.
    ; It should be implemented to create a memory mapping.
    ; A contains flags
    flags := tmp1
    ; Save flags
    sta     flags

    ; Get length (0 to 15 bits)
    jsr     popax
    sta     ptr1
    stx     ptr1 + 1

    ; Get length (16 to 23 bits)
    jsr     popax
    sta     RES
    stx     RES + 1

    lda     ptr1
    ldx     ptr1 + 1
    ldy     flags
    jmp     bms_create

.endproc
