---

## bms_seek

***Description***

Seek in the bms offset

***Input***

* Accumulator : low byte of the bms struct pointer
* X Register : high byte of the bms struct pointer
* Y Register : whence 


***Modify***

* libzp

***Example***

```asm
 lda #<5 ; Offset low
 sta TR0 ; Offset low
 lda #>5 ; Offset high
 sta TR1 ; Offset high
 lda bms_ptr ; Offset High of bms struct
 ldx bms_ptr + 1; Offset High of bms struct
 ldy #BMS_SEEK_CUR
 jsr bms_seek
 jsr rts
```

