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
