ORGADDR	equ $4000	; Origin for the ROM
COM_ACTION_REG:	equ $6FF0	; The command is written here for the Firmware to read
COM_INDEX_REG:	equ $6FF1	; The index for the ROM to load in the current page
COM_ACK_REG:	equ $6FFE	; The Firmware will write the ACK value here for Bootloader to check
COM_START:	equ $7000	; Addresses from 0x7000 to 0x7FFF will trigger the command flow on the Firmware

COM_ACT_PU:	equ $40		; Value for Page Up
COM_ACT_PD:	equ $4F		; Value for Page Down
COM_ACT_PROG:	equ $60		; Value for Program
COM_ACT_DIRIN:	equ $50		; Value for Entering a Dir (Not in v0)
COM_ACT_DIROUT:	equ $5F		; Value for Backing out of a Dir (Not in v0)
