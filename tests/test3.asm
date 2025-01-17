define SCR_LO   $00
define SCR_HI   $02
define NL				$0d
define SPACE		$20

define var_y    $00
define var_x    $01
define ptr_lo   $02
define ptr_hi   $03
define input		$ff

loop_1: ; while
  lda #0 ; uint8_t y = 0
  sta var_y 

loop_2: ; do while
  lda #0 ; uint8_t x = 0
  sta var_x

loop_3: ; do while	
  lda #0 ; uint8_t *ptr = y << 5 | x + SCREEN
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
  lda ptr_hi
  adc #SCR_HI
  sta ptr_hi
  
  lda #0 ; INPUT = 0
  sta input
    
loop_4: ; while
  lda input
  beq loop_4
  
  cmp #NL ; if (INPUT == NL)
  bne elseif_1_1

  lda #0 ; INPUT = 0
  sta input
  
  jmp	sloop_3 ; break
  
elseif_1_1:
  cmp #$27 ; else if (INPUT < 32)
  bne sif_1

  sec
  lda ptr_lo ; ptr--
  sbc #1
  sta ptr_lo
  lda ptr_hi
  sbc #0
  sta ptr_hi
  
  lda #SPACE ; *ptr = SPACE
  sta (ptr_lo,x)
  
  dec var_x ; --x
  lda var_x ; if (x == 0xff)
  cmp #$ff
  bne sif_2

  lda #$1f ; x = 31
  sta var_x
  dec var_y ; y--
  lda var_y ; if (y == 0xff)
  cmp #$ff
  bne sif_3

  lda #$1f ; y = 31
  sta var_y
sif_3:
sif_2:
  
  jmp loop_3 ; continue
  
sif_1:
  lda input ; *ptr = INPUT
  sta (ptr_lo,x)
  
  inc var_x ; x++
  lda var_x
  cmp #32

  bmi loop_3
sloop_3:
  
  inc var_y ; y++
  lda var_y
  cmp #32

  bmi loop_2

  ; brk
  jmp loop_1

irq:
	rti

;
;	#define SCREEN  	(uint8_t*)	0x0200
;	#define INPUT		*((uint8_t*)	0x00FF)
;	#define NL				(uint8_t)		0x0D
;	#define SPACE			(uilt8_t)		0x20
;	
;	while (1) {
;		uint8_t y = 0;
;		do {
;			uint8_t x = 0;
;			do {
;				uint8_t *ptr = y << 5 | x + SCREEN;
;				INPUT = 0;
;				while (!INPUT); // poll
;				if (INPUT == NL) {
;					INPUT = 0;
;					break;	
;				}
;				else if (INPUT < 0x20) {
;					ptr--;
;					*ptr = SPACE;
;					if (--x == 0xff) {
;						x = 31;
;						if (--y == 0xff) {
;							y = 31;
;						}
;					}
;					continue;
;				}
;				*ptr = INPUT;
;				x++;
;			} while (x < 32);
;			y++;
;		} while (y < 32);
;	}
;
