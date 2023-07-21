vasmz80_oldstyle ./main.asm -chklabels -nocase -Dvasm=1 -DBuildMSX=1 -DBuildMSX_MSX1=1 -L out.sym -Fbin -o out.rom
openmsx -cart out.rom
