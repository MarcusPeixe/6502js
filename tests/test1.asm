define INITC    %00001001 ;$09
define MASK1    %00000100 ;$04
define MASK2    %00000011 ;$03
define SCR_LO   $00
define SCR_HI   $02

define colour   $00
define var_y    $01
define var_x    $02
define ptr_lo   $03
define ptr_hi   $04

  lda #INITC
  sta colour
loop_1:

  lda #1
  sta var_y 
  loop_2:
  lda #1
  sta var_x
loop_3:
     
  lda #0
  sta ptr_hi
  lda var_y
  sta ptr_lo
  ldx #5

tloop_1:
  asl ptr_lo
  rol ptr_hi
  dex

  bne tloop_1
  
  lda ptr_lo
  ora var_x
  sta ptr_lo
  
  clc
; lda ptr_lo
; adc #SCR_LO
; sta ptr_lo
  lda ptr_hi
  adc #SCR_HI
  sta ptr_hi
  
  lda colour
  sta (ptr_lo,x)
  
  lda colour
  eor #MASK1
  sta colour

  inc var_x
  lda var_x
  cmp #31

  bmi loop_3
  
  lda colour
  eor #MASK1
  sta colour
  
  inc var_y
  lda var_y
  cmp #31

  bmi loop_2
  
  lda colour
  eor #MASK2
  sta colour

  jmp loop_1

; #define MASK1   0b0000'0100
; #define MASK2   0b0000'0011
; #define INITC   0b0000'1001
; #define SCREEN  0x0200
;
; uint8_t colour = INITC;
;
; while (1) {
;   for (uint8_t y = 0; y < 32; y++) {
;     for (uint8_t x = 0; x < 32; x++) {
;       uint8_t *ptr = y << 5 | x + SCREEN;
;         *ptr = colour;
;         colour ^= MASK1;
;       }
;     colour ^= MASK1;
;   }
;   colour ^= MASK2;
; }
;