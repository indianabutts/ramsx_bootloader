Command_CheckInput:
	;; Check if Input is Idle and backout
	ld hl, (INPUT_STATE)
	ld de, $FFFF
	or a
	sbc hl, de
	add hl, de
	jp z, _Command_CheckInput_Held
	;; Check if Prev and Cur are the same, if so,
	;; juump to input held logic
	ld de, (INPUT_PREV_STATE)
	or a
	sbc hl, de
	add hl, de
	jp z, _Command_CheckInput_Held
	;; Now start comparing for functioanlity
	ld hl, (INPUT_STATE)
	ld a, $FE
	cp h
	call z, COM_PROG_RAM_AREA
	cp l
	call z, Command_Search
	ret
_Command_CheckInput_Held:
	ret
	

Command_Search:
	call VRAM_BackupStatusBar
	ld hl, COM_SEARCH_STATUS_BAR
	call VRAM_SetStatusBar
	call VRAM_CopyWorkBufferToVDP
	ret
	
_Command_Search_Setup
	nop


_Command_WaitForAck:
	ld a, (COM_ACK_REG)
	cp COM_ACK_VALUE
	;; jr nz, _Command_WaitForAck 
	xor a
	ld (COM_ACK_REG), a
	ret
_Command_WaitForAck_End:
	nop
;;; Function: Runs the Programming Command Flow
;;; This function is special since it gets copied into
;;; RAM along with _Command_WaitForAck so that once the
;;; ROM is programmed, we can run this code before resetting
;;; The MSX. Otherwise, it would be overwritten by the new
;;; program
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
	call COM_ACK_RAM_AREA
	ei
	call $0000
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
	
