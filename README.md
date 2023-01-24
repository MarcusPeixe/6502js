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

# Test it out!

You can check out the simulator here: https://marcuspeixe.github.io/6502js/

It runs entirely on the client-side.

# About the simulator

Memory location `$FE` contains a new random byte on every instruction.

Every time a key is pressed, its ASCII code is stored in `$FF`, and a IRQ is
triggered.

If the "Timed IRQs" option is set to a non-zero value, every N milliseconds a
IRQ is triggered and location `$FF` is set to 0.

To assign functions as interrupt handlers, name their label as `res`, `irq` and
`nmi` (RESETs, IRQs and Non Maskable Interrupts, respectively).

To start generating new code at a specific address in memory, you can use the
syntax `* = $xxxx`, where `$xxxx` is that address.

Memory locations `$0200` to `$05FF` map to the screen pixels. Different values will
draw different colour/character pixels. The pixels are:

```
$00: Black
$01: Red
$02: Green
$03: Yellow
$04: Blue
$05: Purple
$06: Cyan
$07: White

$00 - $07: Dark colours
$08 - $0F: Saturated colours
$10 - $17: Bright colours
$18 - $1F: Bright and saturated colours

$20 - $7F: ASCII table

$80 - $BF: Colours (each channel has 2 bit depth)
$C0 - $FF: Greyscale 
```

To extract the low or high byte of a label's address, suffix it with &lt; or &gt;
respectively.
Example:

```
test_label:
  lda #<test_label
  sta $00
  lda #>test_label
  sta $01
```
(Please note it only works with immediate addressing mode)

You can also use the label name without any suffixes in absolute addressing modes.

You can use the keyword `define` to assign names to certain values. These names
can be used throughout your code.

`dcb value, value, ... value` is used to define constant bytes in memory (its
best to use a label right before to provide easy access to them)

Number literal notations are either:

- `123` for decimal
- `$1234` for hex
- `%10101010` for binary

## Example

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