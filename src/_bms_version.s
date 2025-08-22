.include "bms.inc"

.export _bms_version

.import bms_version

.proc _bms_version
    ;;@proto unsigned int bms_version();
    ;;@brief free bms 
    ;;@returns (unsigned int) version

    ; This function returns the version of the bms library.
    ; The version is stored as a string in the data section.

    jmp    bms_version



.endproc

