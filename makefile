all: fproj

simple_io.o: simple_io.asm
	nasm -f elf64 -o simple_io.o simple_io.asm
fproj.o: fproj.asm simple_io.inc
	nasm -f elf64 -o fproj.o fproj.asm
fproj: driver.c fproj.o simple_io.o
	gcc -o fproj driver.c fproj.o simple_io.o
