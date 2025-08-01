.export _bms_error

.import bms_error

.proc _bms_error
    ; This function handles BMS errors.
    ; It expects the error code in the A register.
    jmp     bms_error

.endproc
