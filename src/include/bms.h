#define FLAG_PROT_READ_ONLY  0x00 // On peut lire le contenu de la zone mémoire.
#define FLAG_PROT_READ_WRITE 0x01 //
#define FLAG_PERSISTANT_BANK 0x02 // La banque est persistante, elle ne sera pas libérée à la fin de l'exécution du programme.

#define BMS_MAX_BANKS 1

#define BMS_EOK                       0x00
#define BMS_EBANK_FULL                0x01
#define BMS_CAN_NOT_RUN_INTO_BANK     0x02
#define BMS_LENGTH_REQUESTED_TOO_LONG 0x03

#define BMS_WRITE_MODE  0x00 // Write mode
#define BMS_READ_MODE   0x01 // Read mode



struct bms_struct {
    unsigned int lboundaries[BMS_MAX_BANKS];
    unsigned int hboundaries[BMS_MAX_BANKS];
    unsigned char current_bank_register;
    unsigned char current_set;
    char set[BMS_MAX_BANKS];
    char bank_register[BMS_MAX_BANKS];
    char bankid[BMS_MAX_BANKS];
    char number_of_banks;
    unsigned int fp_offset;
    unsigned int length; // Length of the BMS structure
    char version[10]; // Version string, e.g., "2025.3"
  };


typedef struct bms_struct bms;

bms *bms_create(off_t length, unsigned char flags);

void bms_free(bms *bms);

unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);

unsigned int bms_read_write(bms *bms, unsigned int length, void *data, unsigned mode);
unsigned char bms_error();
unsigned char bms_version();


