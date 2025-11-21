# BMSLIB : Bank Memory System for Twilighte board and Orix

[Documentation](https://orix-software.github.io/bms/)

Lib for bank uses

manage only 1 bank

16000 bytes max can be stored

## Provide

### C

* void *bms_create(size_t length, unsigned char flags);
* unsigned char bms_free(bms *bms);
* unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);
* unsigned int bms_read_write(bms *bms, unsigned int length, void *data, unsigned char mode);
* unsigned char bms_error();
* unsigned char bms_version();

### Usage in assembly language

* bms_create
* bms_free
* bms_seek
* bms_read_write
* bms_error
* bms_version

## Extras

use [bpm](https://github.com/orix-software/bpm) to build

![Arrays](mkdocs/docs/imgs/arrays.png)
