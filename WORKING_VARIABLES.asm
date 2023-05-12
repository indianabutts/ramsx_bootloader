CUR_INDEX:	equ $C001	; Current index of the Cursor
OLD_CUR_INDEX:	equ $C002	; The last index of the Cursor
CUR_GAME:	equ $C003	; The game that was selected
CUR_PAGE:	equ $C004	; The page number
VRM_WRK_AREA:	equ $C100	; Base address for the RAM copy of the VRAM Buffer

COM_ACTION_REG:	equ $6FF0	; The command is written here for the Firmware to read
COM_INDEX_REG:	equ $6FF1	; The index for the ROM to load in the current page
COM_ACK_REG:	equ $6FFE	; The Firmware will write the ACK value here for Bootloader to check
