define SCR_LO   $00
define SCR_HI   $02

define var_y    $00
define var_x    $01
define ptr_lo   $02
define ptr_hi   $03

  lda #0
  sta var_y

loop_2:
  lda #0
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
  
  clc
  lda var_x
  adc var_y
  ora #%11000000
  sta (ptr_lo,x)
  
  inc var_x
  lda var_x
  cmp #32

  bmi loop_3

  inc var_y
  lda var_y
  cmp #32
    
  bmi loop_2

  brk

;
; #define SCREEN  0x0200
;
; for (uint8_t y = 0; y < 32; y++) {
;   for (uint8_t x = 0; x < 32; x++) {
;     uint8_t *ptr = y << 5 | x + SCREEN;
;	  *ptr = x + y | 0xC0;
;   }
; }
;
