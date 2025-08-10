---

## bms_free

***Description***

Free bms struct and liberate banks

***Input***

* Accumulator : low byte of the bms struct pointer
* X Register : high byte of the bms struct pointer


***Modify***

* libzp
* libzp+2
* libzp+4
* libzp+5

***Example***

```asm
 lda bms_ptr
 ldx bms_ptr + 1
 jsr bms_free
 rts
```
Here

