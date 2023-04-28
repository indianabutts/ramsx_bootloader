				; ==[ Constants ]============================================

ORGADR  equ $4000
CHPUT   equ $00A2
CHMOD   equ $005f

CHCOLOR equ $0062

FORCLR equ $F3E9
BAKCLR equ $F3EA
BDCLR equ $F3EB

KBDROW equ $AA
KBDDATA equ $A9
KEYS	EQU	$FBE5

selectorIndex equ $C001
currentGame equ $C003
loopIndex equ $C005
currentPage equ $C006

				; ==[ Header ]==============================================

				; Place header inside the binary.
	org ORGADR
				; ROM header
	db "AB"
	dw Main
	dw 0, 0, 0, 0, 0, 0


games:
	db "10 Yard Fight (1986)", 0
	db "1942 (1986)(ASCII)(J", 0
	db "1942 (1987)(Zemina)(", 0
	db "3D Golf Simulation -", 0
	db "3D Golf Simulation -", 0
	db "3D Tennis (1983)(ASC", 0
	db "3D Water Driver (198", 0
	db "A Life M36 Planet - ", 0
	db "A.E. (1983)(Toshiba-", 0
	db "A1 Spirit - The Way ", 0
	db "Actman (1984)(ASCII)", 0
	db "Adven'chuta! (1983)(", 0
	db "Alcazar - The Forgot", 0
	db "Alibaba and 40 Thiev", 0
	db "Alien 8 (1985)(Ultim", 0
	db "Alien 8 (1986)(Nippo", 0
	db "Aliens. Alien 2 (198", 0
	db "Alpha Roid (1986)(Po", 0
	db "Alpha Squadron (1985", 0
	db "American Truck (1986", 0
	db "American Truck (1986", 0
gamesend:
	nop
				; ==[ Program ]=============================================

FileStart:
Main:
	ld hl, 8
	ld (KBDROW), hl
	; Set Screen Mode to 0
	ld a, 0
	call CHMOD
	; Set Pallette to White on Black
	ld a, 1
	ld (BAKCLR), a
	ld (BDCLR), a
	call CHCOLOR
	; Dummy Dir Name and Go Back to determine maximum games in list
	ld hl, dirName
	call PrintStr
	call NewLn
	ld hl, goBack
	call PrintStr
	call NewLn
	; Load start address for Games List
	ld hl,games
	; ld (currentGame), hl
	; Load end address for Games List
	ld de, gamesend
	; Initialize Loop Index to 0
	ld a, 0 
	ld (loopIndex), a

GamesLoop:
	; Put Pointer Character if LoopIndex is Equ to PointerIndex
	
	;; Store the current HL
	push hl

	ld a, 0
	or a,
	sub 1
	;; Get the Pointer Index
	ld hl, selectorIndex
	ld c, (hl)
	;; Get the LoopIndex	
	ld hl, (loopIndex)
	ld a, l
	cp c
	call z, PrintPointer
	call nz, PrintSpace
	inc hl
	ld (loopIndex), hl
	pop hl
	
	
	;; Compare the two, if equal, then print the pointer, else continue

	;; Restore HL

	
	; Print Current Game Name and a new line
	call PrintStr
	call NewLn
	
	; Compare HL to GamesEnd
	ld a, 0
	or a	; Clears Carry Flag
	inc hl
	ld de, gamesend
	sbc hl,de
	add hl,de
	
	; Loop if HL is less than GamesEnd
	jr c, GamesLoop
	jp MainLoop

PrintStr:
	; Load first character of string to Reg A
	ld a, (hl)
	; If 0 detected, this is the end of the string
	cp 0
	ret z
	; Otherwise, Increment HL and Put the current value pointed to by HL to the screen and loop
	inc hl
	call CHPUT
	jr PrintStr

PrintPointer:
	push af
	ld a, (pointerChar)
	call CHPUT
	pop af
	ret
PrintSpace:
	push af,
	ld a, $20
	call CHPUT
	pop af,
	ret

NewLn:
	push af
	ld a, 13
	call CHPUT
	ld a, 10
	call CHPUT
	pop af
	ret
IncrementSelector:
	ld hl, (selectorIndex)
	inc hl
	ld (selectorIndex), hl
	call GamesLoop
CheckInput:
	ld a, (KEYS+8)
	bit 6, a
	call z, IncrementSelector
	
	; ld b, 8
	; in a, (KBDROW)
	; and $F0
	; or b
	; out ($AA), a
	; in a,($A9)
	; bit 6, a
	; call z, IncrementSelector



MainLoop:
	di
	jp CheckInput
	

goBack:	 db " ..",0
dirName: db " Games/",0
pointerChar:
	db ">"


;; Variables to store in RAM
;;	org $C000
; selectorIndex:
; 	db 0
; currentGame:
; 	dw 0

; loopIndex:
; 	db 0
; currentPage:
; 	db 0