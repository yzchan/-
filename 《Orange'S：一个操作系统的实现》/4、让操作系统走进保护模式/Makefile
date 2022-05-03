##################################################
# Makefile
##################################################

default: boot.bin loader.bin a.img
	dd if=boot.bin of=a.img bs=512 count=1 conv=notrunc
	sudo mount -o loop a.img ./floppy
	sudo cp loader.bin ./floppy/loader.bin -v
#	 sudo cp -r ima/* ./floppy/ -v
	sudo umount ./floppy

a.img:
	dd if=/dev/zero of=a.img bs=1k count=1440

boot.bin : boot.asm
	nasm boot.asm -o boot.bin -l boot.lst

loader.bin : loader.asm
	 nasm loader.asm -o loader.bin -l loader.lst


clean:
	rm -rf a.img *.bin *.log *.lst
