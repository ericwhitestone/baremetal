#!/bin/bash
#mount 2 images, one containing the PBL, don't start cpu, start gdbp port 1234

qemu-system-i386 -drive file=second_stage.bin,index=1,format=raw -drive file=boot.bin,index=0,format=raw -s -S
