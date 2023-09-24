	include "browse_state_screens.asm"
/*
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
	*/
