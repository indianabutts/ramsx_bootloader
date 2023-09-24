				; ==[ Constants ]============================================			
	DEFINE MajorVersion 0
	DEFINE MinorVersion 1
	DEFINE VersionString "0.1"
	DEFINE ORGADDR $4000	; Origin for the ROM
	

	include "sys/bios_calls.asm"
	include "sys/variables.asm"
	
	include "utils/cart_header.asm"
	dw BROWSE_STATE_DISPLAY
	
TOTAL_PAGES:
	dw 30
	include "utils/input_functions.asm"

				; ==[ Program ]=============================================
Init:
	call INITXT
	ld a, 1
	ld (BAKCLR), a
	ld (BDCLR), a
	ld a, 0
	call CHGCLR
	ld a, 10
	call WaitSeconds
	ld hl, SEARCH_STATE_DISPLAY
	call VRAM.CopyBufferToRAM
	call VRAM.CopyWorkBufferToVDP

MainLoopTest:
	call Input.UpdateInputBuffers
	jr MainLoopTest
	
	include "states/splash_state/splash_state.asm"
	include "states/browse_state/browse_state.asm"
	include "states/search_state/search_state.asm"
	include "states/search_result_state/search_result_state.asm"
	include "states/settings_state/settings_state.asm"
        include "utils/util_functions.asm"
	include "utils/gfx_functions.asm"
