# BMS : bank management system

It's a cc65 library for Orix in order to manage bank on twilighte board.

It only manage ram bank.

![Arrays](imgs/array.png)

## Usage in c language

* [void *bms_create(size_t length, unsigned char flags);](_bms_create.md)
* [unsigned char bms_free(bms *bms);](_bms_free.md)
* [unsigned int bms_seek(bms *bms, unsigned int offset, unsigned char whence);](_bms_seek.md)
* [unsigned int bms_write(bms *bms, unsigned int length, void *data);](_bms_write.md)
* [unsigned int bms_read(bms *bms, unsigned int length, void *data);](_bms_read.md)
* [unsigned char bms_error();](_bms_error.md)
* [unsigned char bms_error();](_bms_version.md)

## Usage in assembly language

* [bms_create](bms_create.md)
* [bms_free](bms_free.md)
* [bms_seek](bms_seek.md)
* [bms_write](bms_write.md)
* [bms_read](bms_read.md)
* [bms_error](bms_error.md)
* [bms_version](bms_version.md)

## Examples

* [Examples](example_create_free.md)

