
VRAM_WRK_AREA		equ $C100	; Base address for the RAM copy of the VRAM Buffer
	
;;; TODO: Comment these functions
VRAM:
.CopyWorkBufferToVDP:
	ld bc,960
	ld de, (TXTNAM)
	ld hl, VRAM_WRK_AREA
	call LDIRVM
	ret
;;; Copy Full Buffer Defined in HL to WRK_AREA
.CopyBufferToRAM:
	ld bc, 960
	ld de, VRAM_WRK_AREA
	ldir
	ret

;;VRAM_BackupStatusBar:
;;	ld hl, VRAM_WRK_STATUS_BAR_BASE
;;	ld de, VRAM_STATUS_COPY
;;	ld bc, 40
;;	ldir
;;	ret
;;	
;;VRAM_RestoreStatusBar:	
;;	ld hl, VRAM_STATUS_COPY
;;	ld de, VRAM_WRK_STATUS_BAR_BASE
;;	ld bc, 40
;;	ldir
;;	ret
;;
;;;;; Function: Set Status Bar to whatever buffer is in HL
;;VRAM_SetStatusBar:
;;	ld de, VRAM_WRK_STATUS_BAR_BASE
;;	ld bc, 40
;;	ldir
;;	ret
	
