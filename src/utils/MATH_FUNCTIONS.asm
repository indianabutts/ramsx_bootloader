;;; Mult h by e and place in hl
Mult8x8:
	ld d, 0
	sla h
	sbc a, a
	and e
	ld l,a
	ld b, 7
.Loop:
	add hl, hl
	jr nc, $+3
	add hl, de
	djnz .Loop
	ret

;;; Mult DE by A and store Result in AHL
Mult8x16:
	ld c, 0
	ld h, c
	ld l, h
	add a, a
	jr nc, $+4
	ld h,d
	ld l,e
	ld b,7
.Loop:
	add hl, hl
	rla
	jr nc, $+4
	add hl, de
	adc a, c
	djnz .Loop
	ret
