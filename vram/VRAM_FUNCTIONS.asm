;;; TODO: Comment these functions
	
VRAM_CopyWorkBufferToVDP:
	ld bc, 960
	ld de, (TXTNAM)
	ld hl, VRAM_WRK_AREA
	call LDIRVM
	ret
	
VRAM_CopyBufferToRam:
	ld hl, VRAM_BUFFER
	ld de, VRAM_WRK_AREA
	ld bc, 960
	ldir
	ret

VRAM_BackupStatusBar:
	ld hl, VRAM_WRK_STATUS_BAR_BASE
	ld de, VRAM_STATUS_COPY
	ld bc, 40
	ldir
	ret
	
VRAM_RestoreStatusBar:	
	ld hl, VRAM_STATUS_COPY
	ld de, VRAM_WRK_STATUS_BAR_BASE
	ld bc, 40
	ldir
	ret

;;; Function: Set Status Bar to whatever buffer is in HL
VRAM_SetStatusBar:
	ld de, VRAM_WRK_STATUS_BAR_BASE
	ld bc, 40
	ldir
	ret
	
