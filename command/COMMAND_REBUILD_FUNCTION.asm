Command_Rebuild:
	call VRAM_BackupStatusBar
	ld hl, COM_REBUILD_STATUS_BAR
	call VRAM_SetStatusBar
	call VRAM_CopyWorkBufferToVDP
_Command_Rebuild_Trigger:	
	ld a, COM_ACT_REBUILD
	ld (COM_ACTION_REG), a
	ld (COM_START), a
	call COM_ACK_RAM_AREA
	cp COM_ACK_VALUE
	jp nz, _Command_Rebuild_Trigger
_Command_Rebuild_Complete:
	xor a
	ld (COM_ACK_REG), a
	call VRAM_CopyBufferToRam
	jp VRAM_CopyWorkBufferToVDP
