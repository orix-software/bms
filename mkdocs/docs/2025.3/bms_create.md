---

## bms_create

***Description***

Create slots for bank memory system. Returns NULL and store error, if something is wrong, or returns struct ptr if success

***Input***

* Accumulator : flags (eg : FLAG_PROT_READ_WRITE only supported)
* Y Register : low byte of the length to allocate (0 to 7)
* X Register : high byte of the length to allocate (8 to 15)
* RES : 2 bytes of the length to allocate (16 to 23)

***Modify***

* RES
* TR2
* libzp
* libzp+2
* libzp+4
* libzp+5

***Returns***

* Accumulator : the low ptr for bms struct it returns null ($00 in A and X)
* X Register : the low ptr for bms struct it returns null ($00 in A and X)

!!! note "Use "BMS_CREATE length0_to_15, length16_to_31, flags" macro in 'include/bms.mac'"

***Example***

```asm
 lda #FLAG_PROT_READ_WRITE
 ldx #>15000 ; Length : 15000
 ldy #<15000
 jsr bms_create
 cmp #$00
 bne @not_null
 cpx #$00
 bne @not_null
 ; can not be allocated
 rts
@not_null:
 ...
```

