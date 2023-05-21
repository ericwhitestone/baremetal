.DEFAULT: all

.PHONY: clean

#boot.img: boot.bin
#	./write_disk.sh	

all: boot.bin second_stage.bin

boot.bin: boot.asm
	nasm boot.asm -w+orphan-labels -g -f bin -o boot.bin

second_stage.bin: second_stage.asm
	nasm second_stage.asm -g -f bin -o second_stage.bin

clean:
	rm -f *.bin *.img
