Command_Rebuild:
	call VRAM_BackupStatusBar
	ld hl, COM_REBUILD_STATUS_BAR
	call VRAM_SetStatusBar
	call VRAM_CopyWorkBufferToVDP
	xor a
	ld (COM_SEARCH_LENGTH), a
_Command_Rebuild_Complete:
	ret
