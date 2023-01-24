writescr:
  ldx #0
writescr_loop:
  sta $0200,x
  inx
  bne writescr_loop
  
  rts

res:
  lda #0
  jsr writescr

  brk

irq:
  pha
  txa
  pha
  tsx
  lda $0103,x
  and #%00010000
; BRK
  bne brkloop
; IRQ (keypress)
  lda $ff
  cli
  jsr writescr
  sei
  pla
  tax
  pla

  rti

brkloop:
  cli
  pla
  tax
  pla
brkloop_loop:
; wait
  jmp brkloop_loop

nmi:
  lda #$ff
  sta $040f

  jmp nmi