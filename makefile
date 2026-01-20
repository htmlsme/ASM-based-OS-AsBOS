OPEN:
	nvim src/main.asm

BUILD:
	nasm src/main.asm -f bin -o build/main.bin
	dd if=build/main.bin of=build/image.img bs=512 count=2880
	mkisofs \
  -o build/cd.iso \
  -b main.bin \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  build
	nasm src/main.asm -f bin -o build/main.bin

CLEAN:
	rm -rf ~/osdev/ExoOS/build/*

BOOT_RAW:
	qemu-system-i386 -hda build/main.bin 

BOOT_FLOPPY:
	qemu-system-i386 -fda  build/image.img

BOOT_CD:
	qemu-system-i386 -cdrom build/cd.iso
