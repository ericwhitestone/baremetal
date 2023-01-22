# i386 Bootloader #

## Purpose ##
This project is the documentation of my exploration into x86 bootloaders, architecture, x86 assembly, compilation, and linking. This is an attempt to write some code that does something "interesting" on most x86 machines, and leave behind some starter code artifacts and lessons learns for others that may be interested in something similar. 


## Dependencies for Running and Debugging ## 
    * qemu-system-i386
    * GNU Make
    * gdb 
    * Nasm Assembler  - I am sure alternatives are just as good
    * gcc

## Debugging the Bootloader

GDB Debugging

The `debug` make target will start qemu i386, and wait for gdb to connect. Start gdb and execute:
```
target remote localhost:1234
```

To dump the contents of the bootloader, use objdump since there are no debugging symbols yet. The boot sector must be in a raw binary format. The following is very helpful when stepping through in gdb:

```bash
 objdump -m i8086 --start-address=0x7c00 -b binary -M intel --adjust-vma=0x7c00 -D disk.img
 ```

This will show the 16-Bit real mode portion of the bootloader correctly, up until the far jump into 32-bit Protected mode.
Since the bootsector is always loaded starting at 0x7c00, this will set the offsets properly for viewing.

Execute a similar command for viewing the 32-bit Protected Mode portion that follows the first far jump 0x10:<offset>:

 ```bash
 objdump -m i386 --start-address=0x7c00 -b binary -M intel --adjust-vma=0x7c00 -D disk.img
 ```


 

