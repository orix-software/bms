#define FLAG_PROT_READ_ONLY  0x00 // On peut lire le contenu de la zone mémoire.
#define FLAG_PROT_READ_WRITE 0x01 //
#define FLAG_PERSISTANT_BANK 0x02 // La banque est persistante, elle ne sera pas libérée à la fin de l'exécution du programme.

#define bms_MAX_BANKS 4

struct bms_struct {
    char set[bms_MAX_BANKS];
    char bank[bms_MAX_BANKS];
    char bankid[bms_MAX_BANKS];
    char number_of_banks;
    char version[10]; // Version string, e.g., "2025.3"
};

typedef enum {
  bms_SWITCH_ON = 0,
  bms_SWITCH_OFF = 1,
} bms_SWITCH;

typedef struct bms_struct bms;


bms *bms_create(unsigned int length, unsigned char flags);
unsigned char bms_free(bms *bms);

unsigned char bms_get(bms *bms, unsigned int offset, unsigned int length, void *data);
unsigned char bms_put(bms *bms, unsigned int offset, unsigned int length, void *data);



