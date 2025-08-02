---

## bms_create
***Description***

create slot for bank memory system. Returns NULL and store error, if something is wrong, or returns struct ptr if success
***Input***

* Accumulator : flags 
* X Register : low byte of the length to allocate
* Y Register : high byte of the length to allocate

***Modify***

* RES* TR2* libzp* libzp+2* libzp+4* libzp+5
***Returns***

* Accumulator : retirn,s 
* Accumulator : contains the bank number found
* Accumulator : contains the bank number found
* Accumulator : contains the bank number found


