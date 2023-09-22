;;; Function: Runs the Programming Command Flow
;;; This function is special since it gets copied into
;;; RAM along with _Command_WaitForAck so that once the
;;; ROM is programmed, we can run this code before resetting
;;; The MSX. Otherwise, it would be overwritten by the new
;;; program
Command_ProgramRom:
	ld a, (CUR_INDEX)
	ld (COM_INDEX_REG), a
	ld a, COM_ACT_PROG
	ld (COM_ACTION_REG), a
	ld (COM_START), a
	ld b, $FF
	call COM_ACK_RAM_AREA
	cp COM_ACK_VALUE
	jp nz, COM_PROG_RAM_AREA
	ei
	call CHKRAM
	ret
_Command_ProgramRom_End:
	nop


Command_CopyProgramFunctionsToRAM:
	ld hl, Command_ProgramRom
	ld de, COM_PROG_RAM_AREA
	ld bc, _Command_ProgramRom_End - Command_ProgramRom
	ldir
	ld hl, _Command_WaitForAck
	ld de, COM_ACK_RAM_AREA
	ld bc, _Command_WaitForAck_End - _Command_WaitForAck
	ldir
	ret
	
