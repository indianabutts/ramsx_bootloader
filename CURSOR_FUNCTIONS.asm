	include "CURSOR_CONSTANTS.asm"
	
IncrementCursor:
	ld hl, (CUR_INDEX)
	ld a, l
	ld (OLD_CUR_INDEX),a
	inc hl
	ld a, l
	cp $15
	call z, ZeroCursor
	ld (CUR_INDEX), a
	call UpdateCursor
	call CopyWorkBufferToVRAM
	ret

DecrementCursor:
	ld hl, (CUR_INDEX)
	ld a, l
	ld (OLD_CUR_INDEX),a
	dec hl
	ld a, l
	cp $FF
	call z, ClampCursor
	ld (CUR_INDEX), a
	call UpdateCursor
	call CopyWorkBufferToVRAM
	ret

UpdateCursor:
	;; First we Add the new cursor to the Buffer
	;; We load the CUR_SEL into de, and multiply it by 40
	;; to get the row we are on
	ld a, (CUR_INDEX)
	ld h, a
	ld e, CUR_ROW_LENGTH
	call Mult8x8
	;; We then add the base address of the Buffer to the HL result
	ld de, VRM_WRK_AREA
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
	ld de, VRM_WRK_AREA
	add hl, de
	ld de, CUR_ROW_OFFSET
	add hl, de
	ld (hl), SPACE_CODE
	ret

ZeroCursor:
	xor a
	ret

ClampCursor:
	ld a, $14
	ret
