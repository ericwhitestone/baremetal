#!/bin/bash
dd  bs=512 count=2880 if=/dev/zero of=disk.img 
dd if=boot.bin of=disk.img conv=notrunc
