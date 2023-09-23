compile:
	sjasmplus --lst=out/bootloader.sym --raw=out/bootloader.rom src/bootloader.asm

run: compile
	openmsx out/bootloader.rom

clean:
	rm out/*
