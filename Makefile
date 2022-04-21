all: kernel8.img

boot.o: src/boot.s
	clang -target aarch64-unknown-none -Wall -O2 -ffreestanding -nostdinc -nostdlib -c src/boot.s -o boot.o

kernel8.img: boot.o src/link.ld
	ld.lld -m aarch64elf -nostdlib boot.o -T src/link.ld -o kernel.elf
	llvm-objcopy-10 -O binary kernel.elf kernel8.img

clean:
	rm -f *.img *.elf *.o

run:
	qemu-system-aarch64 -M raspi3 -kernel kernel8.img -d in_asm
