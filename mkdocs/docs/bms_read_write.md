---

## bms_read_write
***Description***

Write bytes
***Input***

* Accumulator : contains the low ptr to the bms structure
* X Register : contains the high ptr byte to the bms structure
* Y Register : mode 
* Y Register : mode 
***Description***

compute bank and set depending of the offset (bms_ptr must be set), and set current bank set


***Modify***

* RESB
* TR0
* libzp
* libzp+9
* libzp+9
* libzp+9
* libzp+9


