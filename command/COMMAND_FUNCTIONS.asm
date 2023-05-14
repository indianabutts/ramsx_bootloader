Command_CheckInput:
_Command_CheckInput_Row8
	;; Checking Row 8 for SPACE, <-, ->
	ld a, (INPUT_STATE+8)
	ld hl, INPUT_PREV_STATE+8
	ld b, (hl)
	cp b
	jr z, _Command_CheckInput_Row5
	;; Check for SPACE = Program Rom
	cp $FE
	call z, COM_PROG_RAM_AREA
	;; Check for -> = Page Up
	cp $EF
	jr z, _Command_CheckInput_Held
	;; Check for <- = Page Down
	cp $7F
	jr z, _Command_CheckInput_Held
_Command_CheckInput_Row5:
	;; Second Stage is ROW 5, to Check for one of the other commands
	;; - Search ($FE)
	ld a, (INPUT_STATE+5)
	ld hl, INPUT_PREV_STATE+5
	ld b, (hl)
	cp b
	ret z
	cp $FE
	call z, Command_Search
	ret
_Command_CheckInput_Held:
	ret
	

Command_Search:
	;; Copy the current Status Bar to RAM
	call VRAM_BackupStatusBar
	;; Transfer the Initial Search Bar into VRAM
	ld hl, COM_SEARCH_STATUS_BAR
	call VRAM_SetStatusBar
	call VRAM_CopyWorkBufferToVDP
	xor a
	ld (COM_SEARCH_LENGTH), a
_Command_Search_ReadTextInput:
	;; First Check for ESC
	ld a, (INPUT_STATE + 7)
	cp $FB
	jr z, _Command_Search_Complete
	;; CAPS $41-$5A
	;; LOWER CAPS + $20
	call Input_UpdateInputBuffers
	jr _Command_Search_ReadTextInput
	
_Command_Search_Setup:	
	nop
	
_Command_Search_Complete:
	call VRAM_RestoreStatusBar
	call VRAM_CopyWorkBufferToVDP
	ret
	

;;; Waits until the ACK value is found in the RAM Location
;;; This is a blocking function and will hold until it can escape
;;; May add a counter to give it an upper limit, since the MSX is held
;;; Once a program is detected. If it's not held/acked within a period
;;; Consider the command to have failed.
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
	
