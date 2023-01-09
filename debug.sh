#!/bin/bash
#mount a disk, boot that disk, don't start cpu, start gdbp port 1234
qemu-system-i386 -drive file=disk.img,format=raw -boot a -s -S
