#include <stdio.h>
#include <conio.h>
#include <unistd.h>
#include "bms.h"

int convert_bms_error_into_string(unsigned char errorcode) {
    printf("Error : ");
    switch (errorcode) {

        case  BMS_EOK:
           puts("EOK");
            /* code */
           break;

        case BMS_EBANK_FULL:
            puts("BMS_EBANK_FULL");
            /* code */
            break;

        case BMS_CAN_NOT_RUN_INTO_BANK:
            puts("BMS_CAN_NOT_RUN_INTO_BANK");
            /* code */
            break;

        case BMS_LENGTH_REQUESTED_TOO_LONG:
            puts("BMS_LENGTH_REQUESTED_TOO_LONG");
            /* code */
            break;

        default:
            printf("Error code unknown");
            break;
    }
}


unsigned char verify[16001];

int main() {
    bms *bms_instance;
    int i;
    off_t length = 640000; // Example length
    char *str_hello = "Hello World";
    // Create a new bms instance
    //memset(verify, 'A', sizeof(verify));
    // for (i = 0; i < 16501; i++) {
    //     verify[i] = 'A';
    // }

    printf("Creating bms instance with length %ld....\n", length);
    bms_instance = bms_create(length, FLAG_PROT_READ_WRITE);
    if (bms_instance == NULL) {
        printf("Failed to create bms instance\n");
        convert_bms_error_into_string(bms_error());

    }
    else {
        // If we can allocate more than 16 bits, it should not work in that
        printf("bms instance created successfully, it's an error.\n");
        convert_bms_error_into_string(bms_error());
        return 1;
    }

    length = 64000;
    printf("Creating bms instance with length %ld....\n", length);
    bms_instance = bms_create(length, FLAG_PROT_READ_WRITE);
    if (bms_instance == NULL) {
        convert_bms_error_into_string(bms_error());
    }
    else {
        printf("bms instance created successfully, it's an error.\n");
        convert_bms_error_into_string(bms_error());
        return 1;
    }

    length = 6400;
    printf("Creating bms instance with length %ld....\n", length);
    bms_instance = bms_create(length, FLAG_PROT_READ_WRITE);
    if (bms_instance == NULL) {
        printf("bms instance did not created successfully, it's an error.\n");
        convert_bms_error_into_string(bms_error());
        return 1;
    }
    else {
        printf("bms instance created successfully.\n");
        convert_bms_error_into_string(bms_error());
    }

    if (bms_instance->number_of_banks != 1 ) {
        printf("Error: Expected 1 banks, but got %d\n", bms_instance->number_of_banks);
        bms_free(bms_instance);
        return 1;
    }

    // Bank %d: set=%d, bank_register=%d,
    puts("+-------------------------------------+");
    puts("| slot|set|breg|bid|lbounds|hbounds   |");
    puts("+-------------------------------------+");

    for (i = 0; i < bms_instance->number_of_banks; i++) {
        printf("|%d    | %d |  %d |%d |     %u | %u    |\n",
                i,
                bms_instance->set[i],
                bms_instance->bank_register[i],
                bms_instance->bankid[i],
                bms_instance->lboundaries[i],
                bms_instance->hboundaries[i]);
    }

    puts("+-------------------------------------+");
    printf("Number of banks : %d\n", bms_instance->number_of_banks);
    printf("Writing . ..\n");
    bms_read_write(bms_instance, 5, str_hello, BMS_WRITE_MODE);
    bms_read_write(bms_instance, 5, str_hello, BMS_WRITE_MODE);

   //bms_read_write(bms_instance, 16001, verify,BMS_WRITE_MODE);

    // // // Free the bms instance
    bms_free(bms_instance);

    // return 0;
}
