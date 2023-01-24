# 6502 Emulator

This project isn't mine. Original code here: https://github.com/skilldrick/6502js

This is a mere version modified by me, which implements a better front-end interface for programming in 6502 Assembly, and a few minor details here and there. All credit goes to skilldrick (https://github.com/skilldrick).

To use this, you must first extract ace-builds-master.zip, then open index.html as you would normally. You can also find example codes labelled testN.txt.

The changes I made to the project were:

+ Added better code editor (https://ace.c9.io/).
+ Created specific syntax highlighter for the 6502 Assembly language.
+ Added emulation speed controls.
+ Added ASCII character support to the canvas (see Notes).
+ Added more colour support.
+ Added "define" command to the assembler.
+ Added binary literals.

* Improved overall layout of the page.
* Added some CSS style and colouring.

- Code window is no longer resizeable.

```
; Sample assembly code:

res:              ; Program entry point
  lda #$41
  ldx #$00
loop:
  sta $0200, x
  eor #$20        ; Fill a quarter of the screen
  inx             ; with alternating 'A' and 'a'
  bne loop        ; characters
  brk

irq:              ; Interrupt service routine
	nop
	lda #>irq       ; Loop forever
	pha
	lda #<irq
	pha
  rts

* = $0700         ; Set Program Counter

dcb 10            ; Define Constant Bytes
dcb $10
dcb %00000010

dcb $12, $34

```