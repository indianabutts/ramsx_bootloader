Command_CheckInput:
_Command_CheckInput_Row8
	;; Checking Row 8 for SPACE, <-, ->
	ld a, (INPUT_STATE+8)
	ld hl, INPUT_PREV_STATE+8
	ld b, (hl)
	cp b
	jr z, _Command_CheckInput_Row5
	cp $FE			;Check for SPACE = Prog Rom
	call z, COM_PROG_RAM_AREA
	cp $7F			; Check for -> = Page Up
	call z, Command_PageUp
	cp $EF			; Check for <- = Page Down
	call z, Command_PageDown
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

Command_PageUp:
	ld a, COM_ACT_PU
	ld (COM_ACTION_REG), a
	ld a, (COM_START)
	ld b, $FF
	call COM_ACK_RAM_AREA
	cp COM_ACK_VALUE
	jp nz, Command_PageUp
	xor a
	ld (COM_ACK_REG), a
	ld (CUR_INDEX), a
	call VRAM_CopyBufferToRam
	call VRAM_CopyWorkBufferToVDP
	ret
Command_PageDown:
	ld a, COM_ACT_PD
	ld (COM_ACTION_REG), a
	ld a, (COM_START)
	ld b, $FF
	call COM_ACK_RAM_AREA
	cp COM_ACK_VALUE
	jp nz, Command_PageDown
	xor a
	ld (COM_ACK_REG), a
	ld (CUR_INDEX), a
	call VRAM_CopyBufferToRam
	call VRAM_CopyWorkBufferToVDP
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
	call Input_UpdateInputBuffers
	;; First Check for ESC
	ld a, (INPUT_STATE + 7)
	cp $FB
	jp z, _Command_Search_Exit
	;; Check for BS
	ld hl, INPUT_PREV_STATE + 7
	ld b, (hl)
	cp b
	jr z, _Command_Search_Ret_Check
	or a
	cp $DF
	jp z, _Command_Search_Backspace
_Command_Search_Ret_Check:
	;; Check for RET and Complete the Flow
	cp $7F
	jr z, _Command_Search_Complete
_Command_Search_Space_Check:
	ld a, (INPUT_STATE+8)
	ld hl, (INPUT_PREV_STATE+8)
	ld b, (hl)
	cp b
	jr z, _Command_Search_Ret_Check
	or a
	ld bc, $0008
	ld ix, SPACE_CODE
	cp $FE
	jr z, _Command_Search_CheckChar
	;; Pseudo Flow
	ld bc, $0002			 ; Set Col (b) to 0, Row (c) 2
	ld ix, $003A			 ; Set IX to ASCII A (0x41) - 7
	ld a, c
	
_Command_Search_ParseRows:
	;; Need to check if the row is unmodified, if it is we increment to the next row
	;; A needs to be preserved
	ld hl, INPUT_STATE
	ld de, 0
	ld e, a
	add hl, de
	ld a, (hl)
_Command_Search_ParseColumns:
	inc ix				 ; Increment the ASCII Code Counter
	bit 0, a  			 ; Check Bit 0
	jr z, _Command_Search_CheckChar ; If Bit 0 is a match, Jump
					 ; to CheckChar Routine	
	inc b				 ; Increment Column
	ld e, a				 ; Store A into E
	ld a, b				 ; Load Column into A
	cp 8				 ; Check if Col is 9
	jr z, _Command_Search_IncRow	 ; Increment Row if True
	ld a, e				 ; Otherwise Restore Value of A from E
	srl a				 ; and Shift A
	jr _Command_Search_ParseColumns

_Command_Search_IncRow:
	inc c			; Increment Row
	ld b, 0			; Reset Column
	ld a, c			; Load Row into A for Compare
	cp 6			; Check if Row is 6
	jr z, _Command_Search_ReadTextInput ;If so, Jump to readTextInput
	jr _Command_Search_ParseRows ;Otherwise, Parse the next Row
_Command_Search_CheckChar:
	;; IX contains the ASCII Character
	;; C contains the ROW

	;;  First we check if this is the same character as before
	ld b, 0
	ld hl, INPUT_STATE
	add hl, bc
	ld a, (hl) 		;Load Current State to A
	ld hl, INPUT_PREV_STATE
	add hl, bc
	ld b, (hl)		;Load Previous State to B
	cp b			;Check, If Equal, Return to ReadInput
	jr z, _Command_Search_ReadTextInput
	ld b, 0
	ld a, (COM_SEARCH_LENGTH)
	ld c, a
	ld hl, COM_SEARCH_QUERY_RAM
	add hl, bc
	ld a, ixl
	ld (hl), a
	ld hl, VRAM_WRK_STATUS_BAR_INPUT_BASE
	add hl, bc
	ld (hl), a
	inc hl
	ld (hl), UNDERSCORE_CODE
	inc c
	ld hl, COM_SEARCH_LENGTH
	ld (hl), c
	call VRAM_CopyWorkBufferToVDP
	jp _Command_Search_ReadTextInput
_Command_Search_Complete:
	nop
	ld hl, COM_SEARCH_QUERY_RAM
	ld a, (COM_SEARCH_LENGTH)
	ld c, a
	ld b, 0
	inc c
	add hl, bc 
	ld (hl), $FF
	ld de, COM_SEARCH_QUERY_ROM
	ld hl, COM_SEARCH_QUERY_RAM
	ldir
_Command_Search_Trigger:
	ld a, COM_ACT_SEARCH
	ld (COM_ACTION_REG), a
	ld (COM_START), a
	ld b, $FF
	call COM_ACK_RAM_AREA
	cp COM_ACK_VALUE
	jp nz, _Command_Search_Trigger
	xor a
	ld (COM_ACK_REG), a
_Command_Search_Exit:
	;; Restore the Status Bar and Return
	;; to Main Loop
	call VRAM_RestoreStatusBar
	call VRAM_CopyWorkBufferToVDP
	ret
_Command_Search_Backspace:
	ld a, (COM_SEARCH_LENGTH)
	
	ld c, a
	ld b, 0
	ld hl, VRAM_WRK_STATUS_BAR_INPUT_BASE
	add hl, bc
	ld (hl), SPACE_CODE
	dec hl
	ld (hl), UNDERSCORE_CODE
	dec a
	ld (COM_SEARCH_LENGTH), a
	call VRAM_CopyWorkBufferToVDP
	jp _Command_Search_ReadTextInput


;;; Waits until the ACK value is found in the RAM Location
;;; This is a blocking function and will hold until it can escape
;;; May add a counter to give it an upper limit, since the MSX is held
;;; Once a program is detected. If it's not held/acked within a period
;;; Consider the command to have failed.
_Command_WaitForAck:
	ld a, (COM_ACK_REG)
	cp COM_ACK_VALUE
	ret z
	dec b
	jp nz, COM_ACK_RAM_AREA
	ret
	;;jp nz, COM_ACK_RAM_AREA
	;; xor a
	;; ld (COM_ACK_REG), a
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
	
