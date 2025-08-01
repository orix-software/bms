

.define FLAG_PROT_READ_ONLY  $00 ; On peut lire le contenu de la zone mémoire.
.define FLAG_PROT_WRITE      $01 ;
.define FLAG_PROT_READ_WRITE $02 ;  La banque est persistante, elle ne sera pas libérée à la fin de l'exécution du programme.

.define XBANK                            $01
.define KERNEL_RAM_BANK_APPLICATION_TYPE $01
.define KERNEL_ALLOCATE_BANK $01
.define KERNEL_FREE_BANK     $02

; Warning low byte must be equal to 00 always, because we check against zero offset to compute set and bank, others values add bugs
.define BMS_MAX_SIZE_PER_BANK $3F00 ; 16K - 32 bytes for the bank header and signature and others bytes reserved fir bms 

BMS_VERSION:
    .asciiz "2025.3"

.ifdef BMS_EXTENDED
.define BMS_LENGTH_BOUNDARIES 4 ; Length of the boundaries in bytes (16 bits each)
.define BMS_MAX_BANKS         1
.else
.define BMS_LENGTH_BOUNDARIES 2 ; Length of the boundaries in bytes (16 bits each)
.define BMS_MAX_BANKS         1
.endif

.define BMS_BANK_HEADER_SIZE 32 ; Size of the bank header in bytes

.define BMS_EOK                       $00
.define BMS_EBANK_FULL                $01
.define BMS_CAN_NOT_RUN_INTO_BANK     $02
.define BMS_LENGTH_REQUESTED_TOO_LONG $03

.define WRITE_MODE  $00 ; Write mode
.define READ_MODE   $01 ; Read mode

.struct bms_struct
    lboundaries         .res BMS_MAX_BANKS * BMS_LENGTH_BOUNDARIES ; Lower boundaries of the banks (16 bits each)
    hboundaries         .res BMS_MAX_BANKS * BMS_LENGTH_BOUNDARIES ; Higher boundaries of the banks (16 bits each)
    current_bank_register .res 1
    current_set          .res 1
    set                 .res BMS_MAX_BANKS
    bank_register       .res BMS_MAX_BANKS ; $321 register
    bankid              .res BMS_MAX_BANKS
    number_of_banks     .res 1 ; Number of banks used
    fp_offset           .res 2
    length              .res 1 ; Length
    version             .res 10
.endstruct

.if     .sizeof(bms_struct) > 255
  .error  "bms_struct size is greater than 255. It's impossible because code does not handle a struct greater than 255"
.endif

libzp := $D0

