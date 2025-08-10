.export _bms_error

.import bms_error

.proc _bms_error
    ;;@proto unsigned char bms_error();
    ;;@brief Returns the last error code from the previous bms command
    ;;@returns error code (unsigned char)
    ; This function handles BMS errors.
    ; It expects the error code in the A register.
    jmp     bms_error

.endproc
