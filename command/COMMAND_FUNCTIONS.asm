
Command_CheckInput:
_Command_CheckInput_Row8:	
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
	
	include "command/COMMAND_PAGING_FUNCTION.asm"
	include "command/COMMAND_SEARCH_FUNCTION.asm"
	include "command/COMMAND_PROG_FUNCTION.asm"
