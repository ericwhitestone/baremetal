.DEFAULT: boot.img

.PHONY: clean

boot.img: boot.bin
	./write_disk.sh	

boot.bin: boot.asm
	nasm boot.asm -w+orphan-labels -g -f bin -o boot.bin

clean:
	rm -f *.bin *.img
