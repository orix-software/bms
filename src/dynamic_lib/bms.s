bms_mapping_dynlib:
.asciiz "dynlib_bms]"
; Include version
.asciiz "2025.2"
.byt 0 ; Module version
.byt 0 ; ROM RAM ?
.addr bms_startup_dynlib ; bms_startup_dynlib Init will be always 0
.proc bms_startup_dynlib
rts
.endproc