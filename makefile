OPEN:
	nvim src/main.asm

BUILD:
	nasm src/main.asm -f bin -o build/main.bin
	cp build/main.bin build/image.img

CLEAN:
	rm -rf ~/Documents/Projects/build/*

BOOT:
	qemu-system-i386 -hda  build/image.img
