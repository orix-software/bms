


=== "C"

    ``` c
    #include <stdio.h>
    #include <unistd.h>
    #include "bms.h"

    int main() {
        bms *bms_instance;
        int i;
        off_t length = 6400; // Example length

        printf("Creating bms instance with length %ld....\n", length);
        bms_instance = bms_create(length, FLAG_PROT_READ_WRITE);
        if (bms_instance == NULL) {
            printf("Failed to create bms instance\n");
            return 0;

        }
        else {
            // If we can allocate more than 16 bits, it should not work in that
            printf("bms instance created successfully, it's an error.\n");
            return 0;
        }
    }

    ```

=== "Assembly/ca65"

    ``` ca65
    .include "bms.inc"
    ```

