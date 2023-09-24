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

;;; Wait by seconds defined in register A
;;; MSX1 has clock speed of 3.58Mhz so we need
;;; to burn 3,580,000 cycles for each second
WaitSeconds:
.ALoop:
	ld b, $FF		; FE42[65090] x 55 ~= 3.58e6 cycles
.CLoop:
	ld c, $42
.Burn:
	ex (sp), ix		; 25 Cycles	
	ex (sp), ix		; 25 Cycles
	dec c			; 5 Cycles, total 55 cycles
	jr nz,.Burn		; If C isn't Zero, burn again
	dec b			
	jr nz,.CLoop		; If B isn't Zero start the C loop again
	dec a
	jr nz,.ALoop
	ret
