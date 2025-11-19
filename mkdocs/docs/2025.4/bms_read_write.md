---

## bms_read_write

***Description***

read or Write bytes (TR0 and TR1 contains the data copied from bank)

***Input***

* Accumulator : contains the low ptr to the bms structure
* X Register : contains the high ptr byte to the bms structure
* Y Register : mode 


***Modify***

* RES
* TR4
* TR5
* TR6
* TR7
* libzp
* libzp+1
* libzp+2
* libzp+3
* libzp+4

***Example***

```asm
 ; Store size
 lda #<5
 sta TR2
 lda #>5
 sta TR3
 ldx #>5
 ; Store ptr
 lda #<str
 sta TR0
 lda #>str
 sta TR1
 ldy #BMS_WRITE_MODE
 lda bms_ptr
 ldx bms_ptr + 1
 jsr bms_read_write
 rts
str:
 .asciiz "hello"
```

***Description***

compute bank and set depending of the offset (bms_ptr must be set), and set current bank set
* RESB
* TR0
* libzp
* libzp+9

