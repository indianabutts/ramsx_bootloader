~/dev/assembler/vasm/vasmz80_oldstyle ./MAIN.asm -chklabels -nocase -Dvasm=1 -DBuildMSX=1 -DBuildMSX_MSX1=1 -L out.sym -Fbin -o out.rom
/Applications/openMSX.app/Contents/MacOS/openmsx -cart out.rom
