;;; Command Memory Locations
COM_ACTION_REG:		equ $6FF0	; The command is written here for the Firmware to read
COM_INDEX_REG:		equ $6FF1	; The index for the ROM to load in the current page
COM_ACK_REG:		equ $6FFE	; The Firmware will write the ACK value here for Bootloader to check
COM_START:		equ $7000	; Addresses from 0x7000 to 0x7FFF will trigger the command flow on the Firmware
COM_SEARCH_QUERY:	equ $DF00 	; Search Query, Terminated with 0xFF
COM_SEARCH_LENGTH:	equ $D6E0	; Search Length
;;; Command Flow Constants for Communicating with MCU
COM_ACT_PU:		equ $40		; Value for Page Up
COM_ACT_PD:		equ $4F		; Value for Page Down
COM_ACT_PROG:		equ $60		; Value for Program
COM_ACT_DIRIN:		equ $50		; Value for Entering a Dir (Not in v0)
COM_ACT_DIROUT:		equ $5F		; Value for Backing out of a Dir (Not in v0)
COM_ACK_VALUE:		equ $A2		; Value that signifies MCU has Acknowledged Command

;;; Command Flow Constants for UX
COM_MAX_SEARCH_LEN:	equ 21		; Max length for search query.
	
;;; RAM Locations for Storing Program Command Instructions
COM_PROG_RAM_AREA:	equ $C900 	;Where the Command_ProgramRom function will be copied to
COM_ACK_RAM_AREA:	equ $CA00 	;Where Wait for Ack function Will Be Copied


