				; ==[ Constants ]============================================

ORGADR  equ $4000
CHPUT   equ $00A2
CHMOD   equ $005f
CHGET equ $009F
CHCOLOR equ $0062

FORCLR equ $F3E9
BAKCLR equ $F3EA
BDCLR equ $F3EB

CLS equ $00C3

KBDROW equ $AA
KBDDATA equ $A9
KEYS	equ	$FBE5
UP_CODE equ $1E
DOWN_CODE equ $1F

SPACE_CHAR equ $20

selectorIndex equ $C001
currentGame equ $C003
loopIndex equ $C005
currentPage equ $C006

				; ==[ Header ]==============================================

				; Place header inside the binary.
	org ORGADR
				; ROM header
	db "AB"
	dw Init
	dw 0, 0, 0, 0, 0, 0


games:
	db "10 Yard Fight (1986)     8kb", 0
	db "1942 (1986)(ASCII)(J     8kb", 0
	db "1942 (1987)(Zemina)(     8kb", 0
	db "3D Golf Simulation -    16kb", 0
	db "3D Golf Simulation -    32kb", 0
	db "3D Tennis (1983)(ASC    32kb", 0
	db "3D Water Driver (198    64kb", 0
	db "A Life M36 Planet -     64kb", 0
	db "A.E. (1983)(Toshiba-    64kb", 0
	db "A1 Spirit - The Way    128kb", 0
	db "Actman (1984)(ASCII)   128kb", 0
	db "Adven'chuta! (1983)(   128kb", 0
	db "Alcazar - The Forgot   128kb", 0
	db "Alibaba and 40 Thiev   256kb", 0
	db "Alien 8 (1985)(Ultim   256kb", 0
	db "Alien 8 (1986)(Nippo   256kb", 0
	db "Aliens. Alien 2 (198   512kb", 0
	db "Alpha Roid (1986)(Po   512kb", 0
	db "Alpha Squadron (1985   512kb", 0
	db "American Truck (1986   512kb", 0
	db "American Truck (1986   512kb", 0
gamesend:
	nop
				; ==[ Program ]=============================================
Init:
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
	
InitGameLoop:
; Dummy Dir Name and Go Back to determine maximum games in list
	xor a
	call CLS
	ld hl, version
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
	call z, PrintInitialPointer
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

PrintInitialPointer:
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
	ld a, l
	cp $15
	call z, ClampSelector
	ld (selectorIndex), hl
	ret

DecrementSelector:
	ld hl, (selectorIndex)
	dec hl
	ld a, l
	cp $FF
	call z, ZeroSelector
	ld (selectorIndex), hl
	ret

ZeroSelector:
	ld hl, 0
	ret

ClampSelector:
	ld hl, $14
	ret
	
CheckInput:
	call CHGET
	cp 30
	call z, DecrementSelector
	cp 31
	call z, IncrementSelector
	ret

MainLoop:
	di
	call CheckInput
	call InitGameLoop
	
	
version: db " Implication Station v0.1",0
goBack:	 db " ..",0
dirName: db " Games/",0
pointerChar:
	db ">"
