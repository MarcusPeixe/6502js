res:
  lda #4
  sta draw_x
  lda #1
  sta draw_y
res_loop1:
  cli
  jsr cls
  lda #<pixelart
  sta draw_spr_LO
  lda #>pixelart
  sta draw_spr_HI
  jsr draw
  inc draw_x
  inc draw_y
; lda draw_y
; cmp #30
  brk
; bmi res_loop1
  brk

irq:
  cli
; tsx
; lda $0101,x
  pla
  and #$10
  bne irq_break
  pla
  pla

  jmp res_loop1

irq_break:
  cli
  pla
  pla

irq_break_loop1:
  jmp irq_break_loop1

; nmi:
; pla
; pla
; pla
; jmp res_loop1

draw:
; Params
define draw_x $00
define draw_y $01
define draw_spr_LO $02
define draw_spr_HI $03
; Vars
define draw_index $04
define draw_i $05
define draw_j $06
define draw_x2 $07
define draw_y2 $08
define draw_ptr_LO $09
define draw_ptr_HI $0A
define draw_colour $0B

  lda #0 ; index = 0
  sta draw_index
  
  lda #0 ; i = 0
  sta draw_i

draw_loop1:
  lda draw_i ; i < 16
  cmp #16
  bpl draw_loop1_break
  
  lda #0 ; j = 0
  sta draw_j

draw_loop2:
  lda draw_j ; j < 16
  cmp #16
  bpl draw_loop2_break

  clc ; x2 = x + j
  lda draw_x
  adc draw_j
  cmp #32
  bpl draw_loop2_continue
  sta draw_x2
  
  clc ; y2 = y + i
  lda draw_y
  adc draw_i
  cmp #32
  bpl draw_loop1_break
  sta draw_y2
  
  lda draw_y2 ; ptr = y2 << 5 | x2 + 0x0200
  sta draw_ptr_LO
  lda #0
  sta draw_ptr_HI
  ldx #5

draw_shift1:
  asl draw_ptr_LO
  rol draw_ptr_HI
  dex

  bne draw_shift1
  lda draw_ptr_LO
  ora draw_x2
  sta draw_ptr_LO
  clc
  lda draw_ptr_HI
  adc #$02
  sta draw_ptr_HI
  
  lda (draw_spr_LO,x) ; *ptr = *spr++
  sta (draw_ptr_LO,x)
  
draw_loop2_continue:	
  clc
  lda draw_spr_LO
  adc #1
  sta draw_spr_LO
  lda draw_spr_HI
  adc #0
  sta draw_spr_HI
  
  inc draw_j ; j++
  jmp draw_loop2

draw_loop2_break:	
  inc draw_i ; i++
  jmp draw_loop1
  draw_loop1_break:

  rts

cls:
  lda #0
  ldx #0
cls_loop:
  sta $0200,x
  sta $0300,x
  sta $0400,x
  sta $0500,x
  inx

  bne cls_loop
  rts

; void draw(uint8_t x, uint8_t y, uint16_t spr) {
; 	for (uint8_t i = 0; i < 16; i++) {
; 		for (uint8_t j = 0; j < 16; j++) {
; 			uint8_t x2 = x + j, y2 = y + i;
; 			uint16_t ptr = y2 << 5 | x2 + 0x0200;
; 			// uint8_t colour = *(spr);
;				// *ptr = colour;
;				*ptr = *spr++;
; 		}
; 	}
; }


pixelart:
  dcb $80, $81, $82, $83, $84, $85, $86, $87
  dcb $88, $89, $8A, $8B, $8C, $8D, $8E, $8F
  dcb $90, $91, $92, $93, $94, $95, $96, $97
  dcb $98, $99, $9A, $9B, $9C, $9D, $9E, $9F
  dcb $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
  dcb $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF
  dcb $B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7
  dcb $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF

  dcb $80, $81, $82, $83, $84, $85, $86, $87
  dcb $88, $89, $8A, $8B, $8C, $8D, $8E, $8F
  dcb $90, $91, $92, $93, $94, $95, $96, $97
  dcb $98, $99, $9A, $9B, $9C, $9D, $9E, $9F
  dcb $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
  dcb $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF
  dcb $B0, $B1, $B2, $B3, $B4, $B5, $B6, $B7
  dcb $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF

  dcb $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7
  dcb $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF
  dcb $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7
  dcb $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF
  dcb $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7
  dcb $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF
  dcb $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7
  dcb $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF

  dcb $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7
  dcb $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF
  dcb $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7
  dcb $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF
  dcb $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7
  dcb $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF
  dcb $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7
  dcb $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF
