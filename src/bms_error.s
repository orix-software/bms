.export bms_error

.import bms_error_var

.proc bms_error
    ;;@brief returns the error code
    ;;@returnsA contains the error code
    lda    bms_error_var
    rts
.endproc
