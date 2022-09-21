.open "sys/main.dol"
.org 0x8017C034
  b readjust_fovy_zoom_in
  
.org 0x8017C1F4
  b readjust_fovy_zoom_out

.org @NextFreeSpace
.global fovy_zoom
fovy_zoom:
  .float 0.75
  
.org @NextFreeSpace
.global set_fovy
set_fovy:
  mflr r0
  stwu sp, -0x40 (sp)
  stw r0, 0x44 (sp)
  stw r3, 0x28 (sp)
  lfs f1, -0x3F3C (rtoc)
  fmuls f1, f31, f1
  lfs f31, -0x3F40 (rtoc)
  fmuls f1, f31, f1
  lis r3, fovy_zoom@ha
  addi r3, r3, fovy_zoom@l
  lfs f31, 0x0 (r3)
  lwz r3, 0x28 (sp)
  cmpwi r3, 0
  beq zoom_in
  fdivs f1, f1, f31
  b zoom_out
  
  zoom_in:
  fmuls f1, f31, f1
  
  zoom_out:
  lfs f31, -0x3F40 (rtoc)
  fadds f1, f1, f1
  fdivs f31, f1, f31
  lwz r0, 0x44 (sp)
  addi sp, sp, 0x40
  mtlr r0
  blr
  
.org @NextFreeSpace
.global readjust_fovy_zoom_in
readjust_fovy_zoom_in:
  li r3, 0
  lfs f31, 0xD0 (r28)
  bl set_fovy
  b 0x8017C038

.org @NextFreeSpace
.global readjust_fovy_zoom_out
readjust_fovy_zoom_out:
  li r3, 1
  bl set_fovy
  stfs f31, 0xD0 (r28)
  b 0x8017C1F8

.close