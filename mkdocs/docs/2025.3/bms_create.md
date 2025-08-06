---

## bms_create
***Description***

create slot for bank memory system. Returns NULL and store error, if something is wrong, or returns struct ptr if success
***Input***

* Accumulator : flags (eg : FLAG_PROT_READ_WRITE only supported)
* Y Register : low byte of the length to allocate (0 to 7)
* X Register : high byte of the length to allocate (8 to 15)
* RES : 2 byte of the length to allocate (16 to 23)

***Modify***

* RES
* TR2
* libzp
* libzp+2
* libzp+4
* libzp+5

***Returns***

* Accumulator : contains the bank number found
!!! note "Use "BMS_CREATE length0_to_15, length16_to_31, flags" macro in 'include/bms.mac'"!!! note "Use "BMS_CREATE length0_to_15, length16_to_31, flags" macro in 'include/bms.mac'"

