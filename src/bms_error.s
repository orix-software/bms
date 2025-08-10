.export bms_error

.import bms_error_var

.proc bms_error
    ;;@brief Returns the error code
    ;;@returnsA contains the error code
    ;;@```asm
    ;;@` jsr bms_error
    ;;@` ; A contains error code
    ;;@` rts
    ;;@```
    lda    bms_error_var
    rts
.endproc
