				; ==[ Constants ]============================================


	include "SYS_BIOSCALLS.asm"
	include "SYS_VARIABLES.asm"
	include "CHAR_CODES.asm"
	include "WORKING_VARIABLES.asm"
	include "CONSTANTS.asm"

	include "CART_HEADER.asm"

	include "VRAM_BUFFER.asm"
	
TOTAL_PAGES:
	dw 30

	include "CURSOR_FUNCTIONS.asm"
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

CopyWorkBufferToVRAM:
	ld bc, 960
	ld de, (TXTNAM)
	ld hl, VRM_WRK_AREA
	call LDIRVM
	ret
	
CopyBufferToRam:
	ld hl, VRAM_BUFFER
	ld de, VRM_WRK_AREA
	ld bc, 960
	ldir
	ret
	


;;; Mult h by e and place in hl
Mult8x8:
	ld d, 0
	sla h
	sbc a, a
	and e
	ld l,a
	ld b, 7
Mult8_8_loop:
	add hl, hl
	jr nc, $+3
	add hl, de
	djnz Mult8_8_loop
	ret
;;; Mult DE by A and store Result in AHL
Mult8x16:
	ld c, 0
	ld h, c
	ld l, h
	add a, a
	jr nc, $+4
	ld h,d
	ld l,e
	ld b,7
Mult8_16_loop:
	add hl, hl
	rla
	jr nc, $+4
	add hl, de
	adc a, c
	djnz Mult8_16_loop
	ret
	
	
CheckInput:
	call CHGET
	cp 30
	call z, DecrementCursor
	cp 31
	call z, IncrementCursor
	ret

MainLoop:
	di
	call CheckInput
	jr MainLoop
		
