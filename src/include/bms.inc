

.define FLAG_PROT_READ_ONLY  $00 ; On peut lire le contenu de la zone mémoire.
.define FLAG_PROT_WRITE      $01 ;
.define FLAG_PROT_READ_WRITE $02 ;  La banque est persistante, elle ne sera pas libérée à la fin de l'exécution du programme.

.define XBANK                            $01
.define KERNEL_RAM_BANK_APPLICATION_TYPE $01
.define KERNEL_ALLOCATE_BANK $01
.define KERNEL_FREE_BANK     $02

.define bms_MAX_BANKS 4

.define BMS_MAX_SIZE_PER_BANK $3FE0 ; 16K - 32 bytes for the bank header and signature

MAPO_VERSION:
    .asciiz "2025.3"

.struct bms_struct
    set                 .res bms_MAX_BANKS
    bank_register       .res bms_MAX_BANKS ; $321 register
    bankid              .res bms_MAX_BANKS
    number_of_banks     .res 1 ; Number of banks used
    version             .res 9
.endstruct

libzp := $D0

