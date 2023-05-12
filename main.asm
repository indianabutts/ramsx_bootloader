				; ==[ Constants ]============================================


	include "SYS_BIOSCALLS.asm"
	include "SYS_VARIABLES.asm"
	include "CHAR_CODES.asm"
	include "WORKING_VARIABLES.asm"
	
ORGADR  equ $4000
	
	include "CART_HEADER.asm"
	include "VRAM_BUFFER.asm"
				; ==[ Program ]=============================================
Init:
	;; Set Screen Mode to 0
	call INITXT
	;; Set Pallette to White on Black
	ld a, 1
	ld (BAKCLR), a
	ld (BDCLR), a
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
	
IncrementSelector:
	;; Will need to blank the current selector on the screen before updating the values
	ld hl, (CUR_SEL_INDEX)
	ld a, l
	ld (OLD_SEL_INDEX),a
	inc hl
	ld a, l
	cp $15
	call z, ZeroSelector
	ld (CUR_SEL_INDEX), a
	call UpdateCursor
	call CopyWorkBufferToVRAM
	ret

DecrementSelector:
	;; Will need to Blank the Current Selector On the screen before updating the value
	ld hl, (CUR_SEL_INDEX)
	ld a, l
	ld (OLD_SEL_INDEX),a
	dec hl
	ld a, l
	cp $FF
	call z, ClampSelector
	ld (CUR_SEL_INDEX), a
	call UpdateCursor
	call CopyWorkBufferToVRAM
	ret

UpdateCursor:
	;; First we Add the new cursor to the Buffer
	;; We load the CUR_SEL into de, and multiply it by 40
	;; to get the row we are on
	ld de, (CUR_SEL_INDEX)
	ld a, 40
	call Mult8x16
	;; We then add the base address of the Buffer to the HL result
	ld de, VRM_WRK_AREA
	add hl, de
	;; We finally add a standard offset of 80 to get it started on the right row
	ld de, 80
	add hl, de
	;; We then Write the character to the location in RAM
	ld (hl), $CF
	;; We repeat for Clearing the OLD_SEL_INDEX
	ld de, (OLD_SEL_INDEX)
	ld a, 40
	call Mult8x16
	ld de, VRM_WRK_AREA
	add hl, de
	ld de, 80
	add hl, de
	ld (hl), $20
	ret

;;; Mult h by e and place in hl
Mult8x8:
	ld d, 0
	sla h
	sbc a, a
	and e
	ld l,a
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
	
ZeroSelector:
	xor a
	ret

ClampSelector:
	ld a, $14
	ret
	
CheckInput:
	call CHGET
	cp 30
	call z, DecrementSelector
	cp 31
	call z, IncrementSelector
	ret

MainLoop:
	di
	call CheckInput
	jr MainLoop
		
