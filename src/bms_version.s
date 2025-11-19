.include "bms.inc"

.export bms_version

.proc bms_version
    ; This function returns the version of the bms library.
    ; The version is stored as a string in the data section.
    ;;@brief returns version
    ; Return from the function
    lda    #BMS_VERSION_2025_4
    rts
.endproc

