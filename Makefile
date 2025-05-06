build-kernel: clean compile-boot compile-kernel link-kernel check-multiboot
clean:
	@rm -rf bin
	@mkdir bin

compile-boot:
	@i686-elf-as src/boot.s -o bin/boot.o
	@echo "Boot compiled"

compile-kernel:
	@i686-elf-gcc -c src/kernel.c -o bin/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	@echo "Kernel compiled"

link-kernel:
	@i686-elf-gcc -T src/linker.ld -o bin/carsar_os.bin -ffreestanding -O2 -nostdlib bin/boot.o bin/kernel.o -lgcc
	@echo "Kernel and boot linked"

check-multiboot:
	@grub-file --is-x86-multiboot bin/carsar_os.bin
	@echo "Multiboot ok"

run-kernel:
	@qemu-system-i386 -kernel bin/carsar_os.bin
