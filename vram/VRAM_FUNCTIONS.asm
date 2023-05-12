;;; TODO: Comment these functions
	
CopyWorkBufferToVRAM:
	ld bc, 960
	ld de, (TXTNAM)
	ld hl, VRM_WRK_AREA
	call LDIRVM
	ret
	
CopyBufferToRam:
	ld hl, VRAM_BUFFER
	ld de, VRM_WRK_AREA
	ld bc, 960
	ldir
	ret
