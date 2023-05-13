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
	ld a, (COM_START)
	nop
	nop
	nop
	nop
	nop
	nop
	call _Command_WaitForAck
	ei
	call $0000
	ret

_Command_WaitForAck:
	ld a, (COM_ACK_REG)
	cp COM_ACK_VALUE
	jr nz, _Command_WaitForAck
	xor a
	ld (COM_ACK_REG), a
	ret
