	/*
==========================
	Input Variables
==========================
	*/
INPUT_STATE:	equ $C020
INPUT_PREV_STATE:	equ $C030

Input:
	/*
	===============================================
	Update Input State Buffers
	Registers - All
	===============================================
	*/
.UpdateInputBuffers:	
	;; First we need to copy the last current state, to the previous state buffer
	ld bc, 10
	ld hl, INPUT_STATE
	ld de, INPUT_PREV_STATE
	ldir
	;; Then we want to go through each row and copy them to INPUT_STATE + Row number
	;; Setup Loop
	ld hl, INPUT_STATE
	ld c,0
.Loop:
	ld a, c
	call SNSMAT
	ld (hl), a
	inc l
	inc c
	ld a, c
	cp 11
	jr nz, .Loop
	;; TODO: Add Logic for handling key being held down.
	ret
