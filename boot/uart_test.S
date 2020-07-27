
loader_test:     file format elf32-tradlittlemips


Disassembly of section .text:

bfc00000 <__start>:

.set noreorder
.set noat
.globl __start
__start:
  nop
bfc00000:	00 00 00 00 02 00 00 10 0c 00 00 10 00 00 00 00     ................

bfc00010 <serial_test>:
  b load_elf
  nop

# for serial test
serial_test:
  la $t0, SERIAL_ADDRESS
bfc00010:	3c08b000 	lui	t0,0xb000
bfc00014:	35081000 	ori	t0,t0,0x1000
  li $t1, 0x41
bfc00018:	24090041 	li	t1,65

bfc0001c <reg_test>:
reg_test:
  lb $t2, LSR_ADDR
bfc0001c:	3c0ab000 	lui	t2,0xb000
bfc00020:	814a1014 	lb	t2,4116(t2)
  andi $t4, $t2, 0x20 
bfc00024:	314c0020 	andi	t4,t2,0x20
  li $t3, 0
bfc00028:	240b0000 	li	t3,0
  beq $t4, $t3, reg_test 
bfc0002c:	118bfffb 	beq	t4,t3,bfc0001c <reg_test>

bfc00030 <loop_write>:
loop_write:
  sw $t1, 0($t0)
bfc00030:	ad090000 	sw	t1,0(t0)
  b reg_test
bfc00034:	1000fff9 	b	bfc0001c <reg_test>
  nop
bfc00038:	00000000 	nop

bfc0003c <load_elf>:


load_elf:
  #dirty hack
  la $t0, (FLASH_START+FLASH_SIZE - 8)
bfc0003c:	3c08beff 	lui	t0,0xbeff
bfc00040:	3508fff8 	ori	t0,t0,0xfff8
  la $t1, 0x00FF
bfc00044:	240900ff 	li	t1,255
  sw $t1, 0($t0)
bfc00048:	ad090000 	sw	t1,0(t0)

  #addr of elfheader, s0
  la $s0, FLASH_START
bfc0004c:	3c10be00 	lui	s0,0xbe00
  #e_magic
  LOAD_WORD_I($t1, 0)
bfc00050:	240f0000 	li	t7,0
bfc00054:	020f7821 	addu	t7,s0,t7
bfc00058:	8de90000 	lw	t1,0(t7)
bfc0005c:	8def0004 	lw	t7,4(t7)
bfc00060:	000f7c00 	sll	t7,t7,0x10
bfc00064:	012f4825 	or	t1,t1,t7
  la $t0, ELF_MAGIC
bfc00068:	3c08464c 	lui	t0,0x464c
bfc0006c:	3508457f 	ori	t0,t0,0x457f
  beq $t0, $t1, 1f
bfc00070:	11090003 	beq	t0,t1,bfc00080 <load_elf+0x44>
  nop
bfc00074:	00000000 	nop
  b bad
bfc00078:	10000042 	b	bfc00184 <bad>
  nop
bfc0007c:	00000000 	nop
1:
  #e_phoff
  LOAD_WORD_I($s1, 28)
bfc00080:	240f0038 	li	t7,56
bfc00084:	020f7821 	addu	t7,s0,t7
bfc00088:	8df10000 	lw	s1,0(t7)
bfc0008c:	8def0004 	lw	t7,4(t7)
bfc00090:	000f7c00 	sll	t7,t7,0x10
bfc00094:	022f8825 	or	s1,s1,t7
  #e_phnum
  LOAD_WORD_I($s2, 44)
bfc00098:	240f0058 	li	t7,88
bfc0009c:	020f7821 	addu	t7,s0,t7
bfc000a0:	8df20000 	lw	s2,0(t7)
bfc000a4:	8def0004 	lw	t7,4(t7)
bfc000a8:	000f7c00 	sll	t7,t7,0x10
bfc000ac:	024f9025 	or	s2,s2,t7
  andi $s2, $s2, 0xFFFF
bfc000b0:	3252ffff 	andi	s2,s2,0xffff

  #e_entry
  LOAD_WORD_I($s3, 24)
bfc000b4:	240f0030 	li	t7,48
bfc000b8:	020f7821 	addu	t7,s0,t7
bfc000bc:	8df30000 	lw	s3,0(t7)
bfc000c0:	8def0004 	lw	t7,4(t7)
bfc000c4:	000f7c00 	sll	t7,t7,0x10
bfc000c8:	026f9825 	or	s3,s3,t7

bfc000cc <next_sec>:

next_sec:
  #s1, addr proghdr
  #s4, p_va
  LOAD_WORD_R($s4, 8, $s1)
bfc000cc:	262f0008 	addiu	t7,s1,8
bfc000d0:	000f7840 	sll	t7,t7,0x1
bfc000d4:	020f7821 	addu	t7,s0,t7
bfc000d8:	8df40000 	lw	s4,0(t7)
bfc000dc:	8def0004 	lw	t7,4(t7)
bfc000e0:	000f7c00 	sll	t7,t7,0x10
bfc000e4:	028fa025 	or	s4,s4,t7
  #s5, p_filesz
  LOAD_WORD_R($s5, 16, $s1)
bfc000e8:	262f0010 	addiu	t7,s1,16
bfc000ec:	000f7840 	sll	t7,t7,0x1
bfc000f0:	020f7821 	addu	t7,s0,t7
bfc000f4:	8df50000 	lw	s5,0(t7)
bfc000f8:	8def0004 	lw	t7,4(t7)
bfc000fc:	000f7c00 	sll	t7,t7,0x10
bfc00100:	02afa825 	or	s5,s5,t7
  #s6, p_offset
  LOAD_WORD_R($s6, 4, $s1)
bfc00104:	262f0004 	addiu	t7,s1,4
bfc00108:	000f7840 	sll	t7,t7,0x1
bfc0010c:	020f7821 	addu	t7,s0,t7
bfc00110:	8df60000 	lw	s6,0(t7)
bfc00114:	8def0004 	lw	t7,4(t7)
bfc00118:	000f7c00 	sll	t7,t7,0x10
bfc0011c:	02cfb025 	or	s6,s6,t7

  beq  $s4, $zero, 3f
bfc00120:	12800010 	beqz	s4,bfc00164 <copy_sec+0x34>
  nop
bfc00124:	00000000 	nop
  beq  $s5, $zero, 3f
bfc00128:	12a0000e 	beqz	s5,bfc00164 <copy_sec+0x34>
  nop
bfc0012c:	00000000 	nop

bfc00130 <copy_sec>:

#copy from file_base+p_offset to p_va
copy_sec:
  LOAD_WORD_R($t0, 0, $s6)
bfc00130:	26cf0000 	addiu	t7,s6,0
bfc00134:	000f7840 	sll	t7,t7,0x1
bfc00138:	020f7821 	addu	t7,s0,t7
bfc0013c:	8de80000 	lw	t0,0(t7)
bfc00140:	8def0004 	lw	t7,4(t7)
bfc00144:	000f7c00 	sll	t7,t7,0x10
bfc00148:	010f4025 	or	t0,t0,t7
  sw $t0, 0($s4)
bfc0014c:	ae880000 	sw	t0,0(s4)
  addiu $s6, $s6, 4
bfc00150:	26d60004 	addiu	s6,s6,4
  addiu $s4, $s4, 4
bfc00154:	26940004 	addiu	s4,s4,4
  addiu $s5, $s5, -4
bfc00158:	26b5fffc 	addiu	s5,s5,-4
  bgtz  $s5, copy_sec
bfc0015c:	1ea0fff4 	bgtz	s5,bfc00130 <copy_sec>
  nop
bfc00160:	00000000 	nop

3:
  addiu $s1, $s1, 32
bfc00164:	26310020 	addiu	s1,s1,32
  addiu $s2, $s2, -1
bfc00168:	2652ffff 	addiu	s2,s2,-1
  bgtz  $s2, next_sec
bfc0016c:	1e40ffd7 	bgtz	s2,bfc000cc <next_sec>
  nop
bfc00170:	00000000 	nop

bfc00174 <done>:

done:
#jump to kernel
  jr $s3
bfc00174:	02600008 	jr	s3
  nop
bfc00178:	00000000 	nop
  b .
bfc0017c:	1000ffff 	b	bfc0017c <done+0x8>
  nop
bfc00180:	00000000 	nop

bfc00184 <bad>:

bad:
  b bad 
bfc00184:	1000ffff 	b	bfc00184 <bad>
  nop
bfc00188:	00000000 	nop
bfc0018c:	00000000 	nop
