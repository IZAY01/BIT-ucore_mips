
loader_test:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <__start>:

.set noreorder
.set noat
.globl __start
__start:
  nop
bfc00000:	00 00 00 00 01 00 00 10 00 00 00 00                 ............

bfc0000c <segtest>:
  b segtest
  nop

# segtest
segtest:
  la $t0,SEG_ADDR
bfc0000c:	3c08b103 	lui	t0,0xb103
  lui $t1,0x1234
bfc00010:	3c091234 	lui	t1,0x1234
  addiu $t1,$t1,0x5678
bfc00014:	25295678 	addiu	t1,t1,22136
  sw $t1,0($t0)
bfc00018:	ad090000 	sw	t1,0(t0)
  nop
bfc0001c:	00000000 	nop

bfc00020 <end_loop>:

end_loop:
  j end_loop
bfc00020:	0bf00008 	j	bfc00020 <end_loop>
  nop
bfc00024:	00000000 	nop

bfc00028 <serial_test>:

# for serial test
serial_test:
  la $t0, SERIAL_ADDRESS
bfc00028:	3c08b000 	lui	t0,0xb000
bfc0002c:	35081000 	ori	t0,t0,0x1000
  li $t1, 0x41
bfc00030:	24090041 	li	t1,65

bfc00034 <reg_test>:
reg_test:
  lb $t2, LSR_ADDR
bfc00034:	3c0ab000 	lui	t2,0xb000
bfc00038:	814a1014 	lb	t2,4116(t2)
  andi $t4, $t2, 0x20 
bfc0003c:	314c0020 	andi	t4,t2,0x20
  li $t3, 0
bfc00040:	240b0000 	li	t3,0
  beq $t4, $t3, reg_test 
bfc00044:	118bfffb 	beq	t4,t3,bfc00034 <reg_test>

bfc00048 <loop_write>:
loop_write:
  sw $t1, 0($t0)
bfc00048:	ad090000 	sw	t1,0(t0)
  b reg_test
bfc0004c:	1000fff9 	b	bfc00034 <reg_test>
  nop
bfc00050:	00000000 	nop

bfc00054 <load_elf>:


load_elf:
  #dirty hack
  la $t0, (FLASH_START+FLASH_SIZE - 8)
bfc00054:	3c08beff 	lui	t0,0xbeff
bfc00058:	3508fff8 	ori	t0,t0,0xfff8
  la $t1, 0x00FF
bfc0005c:	240900ff 	li	t1,255
  sw $t1, 0($t0)
bfc00060:	ad090000 	sw	t1,0(t0)

  #addr of elfheader, s0
  la $s0, FLASH_START
bfc00064:	3c10be00 	lui	s0,0xbe00
  #e_magic
  LOAD_WORD_I($t1, 0)
bfc00068:	240f0000 	li	t7,0
bfc0006c:	020f7821 	addu	t7,s0,t7
bfc00070:	8de90000 	lw	t1,0(t7)
bfc00074:	8def0004 	lw	t7,4(t7)
bfc00078:	000f7c00 	sll	t7,t7,0x10
bfc0007c:	012f4825 	or	t1,t1,t7
  la $t0, ELF_MAGIC
bfc00080:	3c08464c 	lui	t0,0x464c
bfc00084:	3508457f 	ori	t0,t0,0x457f
  beq $t0, $t1, 1f
bfc00088:	11090003 	beq	t0,t1,bfc00098 <load_elf+0x44>
  nop
bfc0008c:	00000000 	nop
  b bad
bfc00090:	10000042 	b	bfc0019c <bad>
  nop
bfc00094:	00000000 	nop
1:
  #e_phoff
  LOAD_WORD_I($s1, 28)
bfc00098:	240f0038 	li	t7,56
bfc0009c:	020f7821 	addu	t7,s0,t7
bfc000a0:	8df10000 	lw	s1,0(t7)
bfc000a4:	8def0004 	lw	t7,4(t7)
bfc000a8:	000f7c00 	sll	t7,t7,0x10
bfc000ac:	022f8825 	or	s1,s1,t7
  #e_phnum
  LOAD_WORD_I($s2, 44)
bfc000b0:	240f0058 	li	t7,88
bfc000b4:	020f7821 	addu	t7,s0,t7
bfc000b8:	8df20000 	lw	s2,0(t7)
bfc000bc:	8def0004 	lw	t7,4(t7)
bfc000c0:	000f7c00 	sll	t7,t7,0x10
bfc000c4:	024f9025 	or	s2,s2,t7
  andi $s2, $s2, 0xFFFF
bfc000c8:	3252ffff 	andi	s2,s2,0xffff

  #e_entry
  LOAD_WORD_I($s3, 24)
bfc000cc:	240f0030 	li	t7,48
bfc000d0:	020f7821 	addu	t7,s0,t7
bfc000d4:	8df30000 	lw	s3,0(t7)
bfc000d8:	8def0004 	lw	t7,4(t7)
bfc000dc:	000f7c00 	sll	t7,t7,0x10
bfc000e0:	026f9825 	or	s3,s3,t7

bfc000e4 <next_sec>:

next_sec:
  #s1, addr proghdr
  #s4, p_va
  LOAD_WORD_R($s4, 8, $s1)
bfc000e4:	262f0008 	addiu	t7,s1,8
bfc000e8:	000f7840 	sll	t7,t7,0x1
bfc000ec:	020f7821 	addu	t7,s0,t7
bfc000f0:	8df40000 	lw	s4,0(t7)
bfc000f4:	8def0004 	lw	t7,4(t7)
bfc000f8:	000f7c00 	sll	t7,t7,0x10
bfc000fc:	028fa025 	or	s4,s4,t7
  #s5, p_filesz
  LOAD_WORD_R($s5, 16, $s1)
bfc00100:	262f0010 	addiu	t7,s1,16
bfc00104:	000f7840 	sll	t7,t7,0x1
bfc00108:	020f7821 	addu	t7,s0,t7
bfc0010c:	8df50000 	lw	s5,0(t7)
bfc00110:	8def0004 	lw	t7,4(t7)
bfc00114:	000f7c00 	sll	t7,t7,0x10
bfc00118:	02afa825 	or	s5,s5,t7
  #s6, p_offset
  LOAD_WORD_R($s6, 4, $s1)
bfc0011c:	262f0004 	addiu	t7,s1,4
bfc00120:	000f7840 	sll	t7,t7,0x1
bfc00124:	020f7821 	addu	t7,s0,t7
bfc00128:	8df60000 	lw	s6,0(t7)
bfc0012c:	8def0004 	lw	t7,4(t7)
bfc00130:	000f7c00 	sll	t7,t7,0x10
bfc00134:	02cfb025 	or	s6,s6,t7

  beq  $s4, $zero, 3f
bfc00138:	12800010 	beqz	s4,bfc0017c <copy_sec+0x34>
  nop
bfc0013c:	00000000 	nop
  beq  $s5, $zero, 3f
bfc00140:	12a0000e 	beqz	s5,bfc0017c <copy_sec+0x34>
  nop
bfc00144:	00000000 	nop

bfc00148 <copy_sec>:

#copy from file_base+p_offset to p_va
copy_sec:
  LOAD_WORD_R($t0, 0, $s6)
bfc00148:	26cf0000 	addiu	t7,s6,0
bfc0014c:	000f7840 	sll	t7,t7,0x1
bfc00150:	020f7821 	addu	t7,s0,t7
bfc00154:	8de80000 	lw	t0,0(t7)
bfc00158:	8def0004 	lw	t7,4(t7)
bfc0015c:	000f7c00 	sll	t7,t7,0x10
bfc00160:	010f4025 	or	t0,t0,t7
  sw $t0, 0($s4)
bfc00164:	ae880000 	sw	t0,0(s4)
  addiu $s6, $s6, 4
bfc00168:	26d60004 	addiu	s6,s6,4
  addiu $s4, $s4, 4
bfc0016c:	26940004 	addiu	s4,s4,4
  addiu $s5, $s5, -4
bfc00170:	26b5fffc 	addiu	s5,s5,-4
  bgtz  $s5, copy_sec
bfc00174:	1ea0fff4 	bgtz	s5,bfc00148 <copy_sec>
  nop
bfc00178:	00000000 	nop

3:
  addiu $s1, $s1, 32
bfc0017c:	26310020 	addiu	s1,s1,32
  addiu $s2, $s2, -1
bfc00180:	2652ffff 	addiu	s2,s2,-1
  bgtz  $s2, next_sec
bfc00184:	1e40ffd7 	bgtz	s2,bfc000e4 <next_sec>
  nop
bfc00188:	00000000 	nop

bfc0018c <done>:

done:
#jump to kernel
  jr $s3
bfc0018c:	02600008 	jr	s3
  nop
bfc00190:	00000000 	nop
  b .
bfc00194:	1000ffff 	b	bfc00194 <done+0x8>
  nop
bfc00198:	00000000 	nop

bfc0019c <bad>:

bad:
  b bad 
bfc0019c:	1000ffff 	b	bfc0019c <bad>
  nop
bfc001a0:	00000000 	nop
	...
