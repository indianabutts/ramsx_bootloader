	include "cursor/CURSOR_CONSTANTS.asm"

Cursor_CheckInput:
	ld hl,(INPUT_STATE)
	ld a, h
	ld hl, (INPUT_PREV_STATE)
	ld b, h
	cp b
	jr z, _Cursor_CheckInput_Held
	cp $DF
	call z, Cursor_DecrementIndex
	cp $BF
	call z, Cursor_IncrementIndex
	ret
_Cursor_CheckInput_Held:
	ret
	
	
Cursor_IncrementIndex:
	ld hl, (CUR_INDEX)
	ld a, l
	ld (OLD_CUR_INDEX),a
	inc hl
	ld a, l
	cp $15
	call z, _Cursor_ZeroIndex
	ld (CUR_INDEX), a
	call _Cursor_UpdateScreenPosition
	call VRAM_CopyWorkBufferToVDP
	ret

Cursor_DecrementIndex:
	ld hl, (CUR_INDEX)
	ld a, l
	ld (OLD_CUR_INDEX),a
	dec hl
	ld a, l
	cp $FF
	call z, _Cursor_ClampIndex
	ld (CUR_INDEX), a
	call _Cursor_UpdateScreenPosition
	call VRAM_CopyWorkBufferToVDP
	ret

_Cursor_UpdateScreenPosition:
	;; First we Add the new cursor to the Buffer
	;; We load the CUR_SEL into de, and multiply it by 40
	;; to get the row we are on
	ld a, (CUR_INDEX)
	ld h, a
	ld e, CUR_ROW_LENGTH
	call Mult8x8
	;; We then add the base address of the Buffer to the HL result
	ld de, VRAM_WRK_AREA
	add hl, de
	;; We finally add a standard offset of 80 to get it started on the right row
	ld de, CUR_ROW_OFFSET
	add hl, de
	;; We then Write the character to the location in RAM
	ld (hl), POINTER_CODE
	;; We repeat for Clearing the OLD_SEL_INDEX
	ld a, (OLD_CUR_INDEX)
	ld h, a
	ld e, CUR_ROW_LENGTH
	call Mult8x8
	ld de, VRAM_WRK_AREA
	add hl, de
	ld de, CUR_ROW_OFFSET
	add hl, de
	ld (hl), SPACE_CODE

_Cursor_ZeroIndex:
	xor a
	ret

_Cursor_ClampIndex:
	ld a, $14
	ret
