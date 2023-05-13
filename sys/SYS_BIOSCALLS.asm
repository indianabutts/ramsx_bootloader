;;; MSX BIOS Calls
;;; Information from : http://map.grauw.nl/resources/msxbios.php


;;; ====================================================
;;; Block Transfer to VRAM from memory
;;; Inputs:
;;;       BC - Block Length
;;;       DE - Start of VRAM
;;;       HL - Start address of memory
;;; Registers: All
;;; ====================================================
LDIRVM: equ $005C

;;; ====================================================
;;; Changes the screen colors
;;; Inputs:
;;;       Foreground Color in FORCLR
;;;       Background Color in BAKCLR
;;;       Border Color in BDRCLR
;;; Registers: All
;;; ====================================================
CHGCLR:	equ $0062

;;; ====================================================
;;; Clears the screen
;;; Inputs:
;;;       Foreground Color in FORCLR
;;;       Background Color in BAKCLR
;;;       Border Color in BDRCLR
;;; Registers: All
;;; ====================================================
CLS:	equ $00C3

;;; ====================================================
;;; Switches to SCREEN 0 (text screen with 40×24 characters)Clears the screen
;;; Inputs:
;;;       TXTNAM
;;;       TXTCGP
;;; Registers: All
;;; ====================================================
INITXT:	equ #006C

;;; ====================================================
;;; One character input (waiting)
;;; Output:
;;;       A - ASCII Code of the input character
;;; Registers: AF
;;; ====================================================	
CHGET:	equ $009F

;;; ====================================================
;;; Returns the value of the specified line from the keyboard matrix
;;; Input:
;;; 	  A - The specified line 
;;; Output:
;;;       A - Data with Key Press represented as 0
;;; Registers: AF
;;; ====================================================	
SNSMAT:	equ $0141

;;; ====================================================
;;; Also called STARTUP, RESET or BOOT - Tests RAM and
;;; sets RAM slot for the system
;;; Registers: All
;;; Remark: After this, a jump must be made to INIT, for
;;;         further initialization.
;;; ====================================================	
CHKRAM:	equ $0000
