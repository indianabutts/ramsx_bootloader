				; ==[ Constants ]============================================


	include "SYS_BIOSCALLS.asm"
	include "SYS_VARIABLES.asm"
	include "CHAR_CODES.asm"
	include "CURSOR_VARIABLES.asm"
	include "VRAM_VARIABLES.asm"
	include "INPUT_VARIABLES.asm"
	include "MAIN_CONSTANTS.asm"
	include "COMMAND_CONSTANTS.asm"
	include "INPUT_CONSTANTS.asm"

	include "CART_HEADER.asm"

	include "VRAM_BUFFER.asm"
	
TOTAL_PAGES:
	dw 30

	include "CURSOR_FUNCTIONS.asm"
	include "VRAM_FUNCTIONS.asm"
	include "MATH_FUNCTIONS.asm"
	include "INPUT_FUNCTIONS.asm"
				; ==[ Program ]=============================================
Init:
	;; Set Screen Mode to 0
	call INITXT
	;; Set Pallette to White on Black
	ld a, 1
	ld (BAKCLR), a
	ld (BDCLR), a
	ld a, 0
	ld (CUR_INDEX),a
	ld (OLD_CUR_INDEX),a
	call CHGCLR
	;; Copy the VRAM_BUFFER to RAM so that we can update it
	call CopyBufferToRam
	;; Copy the VRAM_BUFFER in RAM to VRAM
	call CopyWorkBufferToVRAM
	call MainLoop



CheckBiosInput:
	call CHGET
	cp UP_CODE
	call z, Cursor_DecrementIndex
	cp DOWN_CODE
	call z, Cursor_DecrementIndex
	ret

MainLoop:
	di
	call Input_UpdateInputBuffers
	call Cursor_CheckInput
	jr MainLoop
		
