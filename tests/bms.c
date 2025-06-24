#include <stdio.h>
#include <conio.h>
#include "bms.h"

int main() {
    bms *bms_instance;
    unsigned int length = 64000; // Example length

    // Create a new bms instance

    printf("Creating bms instance with length %u...\n", length);
    bms_instance = bms_create(length, FLAG_PROT_READ_WRITE);
    if (bms_instance == NULL) {
        printf("Failed to create bms instance\n");
        return 1;
    }
    else {
        printf("bms instance created successfully.\n");
    }

    printf("Number of banks : %d\n", bms_instance->number_of_banks);


    // // // Free the bms instance
    bms_free(bms_instance);

    // return 0;
}
