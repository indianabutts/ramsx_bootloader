Input_UpdateInputBuffers:
	;; First we need to copy the last current state, to the previous state buffer
	ld bc, 10
	ld hl, INPUT_STATE
	ld de, INPUT_PREV_STATE
	ldir
	;; Then we want to go through each row and copy them to INPUT_STATE + Row number

	;; Setup Loop
	ld hl, INPUT_STATE
	ld c,0
_Input_UpdateInputBuffers_Loop:	
	ld a, c
	call SNSMAT
	ld (hl), a
	inc l
	inc c
	ld a, c
	cp 11
	jr nz, _Input_UpdateInputBuffers_Loop
	;; TODO: Add Logic for handling key being held down.
	ret
	
_Input_ClearRepeat:	
	ld a, 0
	ld (INPUT_CUR_REP_COUNT), a
	ret
	
_Input_IncrementRep:
	ld a, (INPUT_CUR_REP_COUNT)
	inc a
	cp INPUT_REP_COUNT
	jr z, _Input_IncrementRep_Over
	ret
_Input_IncrementRep_Over:
	ld a, 0
	ld (INPUT_CUR_REP_COUNT), a
	ret
	
