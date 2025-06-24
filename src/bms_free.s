.export bms_free

.include "telestrat.inc"
.include "bms.inc"

.proc bms_free
   ; print str_bank_id_given
    ; lda     #KERNEL_FREE_BANK    ; Mode : allocate bank
    ; ldx     #34 ; X the type of bank (persistant bank)
    ; BRK_TELEMON XBANK ; GET free bank
; str_free_id:
;     .asciiz "Free bank id : "
    lda     #$00
    rts
.endproc
