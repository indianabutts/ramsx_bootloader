				; ==[ Constants ]============================================

ORGADR  equ $4000
CHPUT   equ $00A2
CHMOD   equ $005f

CHCOLOR equ $0062

FORCLR equ $F3E9
BAKCLR equ $F3EA
BDCLR equ $F3EB
RomSize equ $4000
	

				; ==[ Header ]==============================================

				; Place header inside the binary.
	org ORGADR
				; ROM header
	db "AB"
	dw Main
	dw 0, 0, 0, 0, 0, 0

				; ==[ Program ]=============================================

FileStart:
Main:
				; set VDP to screen 0

	ld a, 0
	call CHMOD
	ld a, 1

	ld (BAKCLR), a
	ld (BDCLR), a
	call CHCOLOR
	ld hl, dirName
	call PrintStr
	call NewLn
	ld hl, goBack
	call PrintStr
	call NewLn
	ld hl,games
	ld de, gamesend

GamesLoop:
	call PrintStr
	call NewLn
	inc hl
	inc b
	or a
	sbc hl,de
	add hl,de
	jr c, GamesLoop
	call Finished
	
PrintStr:
	ld a, (hl)
	cp 0
	ret z
	inc hl
	call CHPUT
	jr PrintStr

NewLn:
	push af
	ld a, 13
	call CHPUT
	ld a, 10
	call CHPUT
	pop af
	ret

Finished:
	di
	halt

goBack:	 db " ..",0
dirName: db " Games/",0
pointerChar:
	db ">",0
emptyPointer:
	db " ",0
games:
	db " 10 Yard Fight (1986)", 0
	db " 1942 (1986)(ASCII)(J", 0
	db " 1942 (1987)(Zemina)(", 0
	db " 3D Golf Simulation -", 0
	db " 3D Golf Simulation -", 0
	db " 3D Tennis (1983)(ASC", 0
	db " 3D Water Driver (198", 0
	db " A Life M36 Planet - ", 0
	db " A.E. (1983)(Toshiba-", 0
	db " A1 Spirit - The Way ", 0
	db " Actman (1984)(ASCII)", 0
	db " Adven'chuta! (1983)(", 0
	db " Alcazar - The Forgot", 0
	db " Alibaba and 40 Thiev", 0
	db " Alien 8 (1985)(Ultim", 0
	db " Alien 8 (1986)(Nippo", 0
	db " Aliens. Alien 2 (198", 0
	db " Alpha Roid (1986)(Po", 0
	db " Alpha Squadron (1985", 0
	db " American Truck (1986", 0
	db " American Truck (1986", 0
gamesend:
	nop

selectorIndex:
	db 0

currentPage:
	db 0