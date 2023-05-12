Command_CheckInput:
	ld hl, (INPUT_STATE)
	ld a, h
	ld hl, (INPUT_PREV_STATE)
	ld b, h
	cp b,
	jr z, _Command_CheckInput_Held
	cp $FE
	call z, Command_ProgramRom
	ret
_Command_CheckInput_Held:
	ret

Command_ProgramRom:
	ld a, (CUR_INDEX)
	ld (COM_INDEX_REG), a
	ld a, (COM_ACT_PROG)
	ld (COM_ACTION_REG), a
	ld a,(COM_START)
	ret

