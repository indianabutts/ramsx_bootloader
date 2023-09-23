	DEFINE MajorVersion 0
	DEFINE MinorVersion 1
	DEFINE VersionString "0.1"
				; ==[ Constants ]============================================


	include "sys/SYS_BIOSCALLS.asm"
	include "sys/SYS_VARIABLES.asm"
	include "utils/CHAR_CODES.asm"
	include "cursor/CURSOR_VARIABLES.asm"
	include "vram/VRAM_VARIABLES.asm"
	include "input/INPUT_VARIABLES.asm"
	include "MAIN_CONSTANTS.asm"
	include "command/COMMAND_CONSTANTS.asm"
	include "input/INPUT_CONSTANTS.asm"
	include "vram/VRAM_CONSTANTS.asm"
	include "utils/CART_HEADER.asm"

	include "vram/VRAM_BUFFER.asm"
	
TOTAL_PAGES:
	dw 30

	include "cursor/CURSOR_FUNCTIONS.asm"
	include "vram/VRAM_FUNCTIONS.asm"
	include "utils/MATH_FUNCTIONS.asm"
	include "input/INPUT_FUNCTIONS.asm"
	include "command/COMMAND_FUNCTIONS.asm"



				; ==[ Program ]=============================================
Init:
	call INITXT
	ld a, 1
	ld (BAKCLR), a
	ld (BDCLR), a
	ld a, 0
	call CHGCLR
	ld hl, SPLASH_STATE_DISPLAY
	ld de, (TXTNAM)
	ld bc, 960
	call LDIRVM

MainLoopTest:
	jr MainLoopTest
InitTemp:
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
	call Command_CopyProgramFunctionsToRAM
	;; Copy the VRAM_BUFFER to RAM so that we can update it
	call VRAM_CopyBufferToRam
	;; Copy the VRAM_BUFFER in RAM to VRAM
	call VRAM_CopyWorkBufferToVDP
	call MainLoop

MainLoop:
	di
	call Input_UpdateInputBuffers
	call Cursor_CheckInput
	call Command_CheckInput
	jr MainLoop

	include "command/COMMAND_DATA.asm"
	include "command/COMMAND_VARIABLES.asm"
	include "states/splash_state/splash_state.asm"
