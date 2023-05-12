Input_UpdateInputBuffers:	
	;; Set Previous State to the last current state before check
	ld hl, (INPUT_STATE)
	ld (INPUT_PREV_STATE), hl
	;; Copy Previous State into B for Comparison later
	
	;; Call SNSMAT to get the state for the ROW
	;; and store it in RAM
	ld a, INPUT_NAV_ROW
	call SNSMAT
	ld h, a
	ld a, INPUT_COM_ROW
	call SNSMAT
	ld l, a
	ld (INPUT_STATE), hl
	;; Compare New State in A with Previous State in B
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
	
	;ld (
	;cp $FF
	;jr z,CheckNavInput
	;;; Row 8 Has Sequence
	;;; R, D, U, L
	;;; Check for U = 11011111 (0xDF)
	;cp $DF
	;call z, DecrementCursor
	;;; Check for D = 10111111 (0xBF)
	;cp $BF
	;call z, IncrementCursor
	;ret

