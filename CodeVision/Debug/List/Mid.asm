
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _LCD_ref=R4
	.DEF _LCD_ref_msb=R5
	.DEF _i=R6
	.DEF _i_msb=R7
	.DEF _digit1=R9
	.DEF _digit2=R8
	.DEF _key=R11
	.DEF _flag=R10
	.DEF _minutes=R12
	.DEF _minutes_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  _timer1_compb_isr
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_segments:
	.DB  0x40,0x0,0x79,0x0,0x24,0x0,0x30,0x0
	.DB  0x19,0x0,0x12,0x0,0x2,0x0,0x78,0x0
	.DB  0x0,0x0,0x10,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x32
_0x4:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x78
	.DB  0x31,0x32,0x33,0x2D,0x63,0x30,0x3D,0x2B

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _keys
	.DW  _0x4*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;// Declare your global variables here
;int LCD_ref=0x01, i=0, digit[4];
;unsigned char digit1=0,digit2= 0, key, flag;
;   int minutes = 0,seconds = 0, test=50,remaining_seconds, remaining_minutes;

	.DSEG
;#define col0    PINA.0
;#define col1    PINA.1
;#define col2    PINA.2
;#define col3    PINA.3
;
;    const int segments[] =
;     {
;        0x40, // 0
;        0x79, // 1
;        0x24, // 2
;        0x30, // 3
;        0x19, // 4
;        0x12, // 5
;        0x02, // 6
;        0x78, // 7
;        0x00, // 8
;        0x10 // 9
;    };
;
;    char keys[]= {                      //based on keypad model we use
;              '7', '8', '9', '/',
;              '4', '5', '6', 'x',
;              '1', '2', '3', '-',
;              'c', '0', '=', '+'
;              };
;
;//                  char keys[]= {                      //based on keypad model we use
;//              '/','1', '2', '3',
;//              '+','4', '5', '6',
;//              '-','7', '8', '9',
;//              'x','c', '0', '='
;//              };
;
;//char ref[]= {0xF7,0xF6,0xFB,0xF7};
;
;// Function prototypes
;void display_on_seven_segment_minute(char minute);
;void display_on_seven_segment_second(char second);
;char read_keypad();
;int getval(char key);
;void blink_segment_minute(char mode);
;void LightDancer();
;void sound_buzzer();
;
;
;
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 0036 {

	.CSEG
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0037  //Place your code here
; 0000 0038 
; 0000 0039     PORTD = (LCD_ref);
	OUT  0x12,R4
; 0000 003A     PORTC = (segments[digit[i]]);
	MOVW R30,R6
	LDI  R26,LOW(_digit)
	LDI  R27,HIGH(_digit)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LDI  R26,LOW(_segments*2)
	LDI  R27,HIGH(_segments*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	OUT  0x15,R0
; 0000 003B     LCD_ref = LCD_ref<<1;
	LSL  R4
	ROL  R5
; 0000 003C     i++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 003D     if (i == 4)
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x5
; 0000 003E     {
; 0000 003F         i = 0;
	CLR  R6
	CLR  R7
; 0000 0040         LCD_ref = 0x01;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
; 0000 0041     }
; 0000 0042 
; 0000 0043 }
_0x5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 0046 {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0047     remaining_seconds--;
	LDI  R26,LOW(_remaining_seconds)
	LDI  R27,HIGH(_remaining_seconds)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0048 
; 0000 0049     if (remaining_seconds == 0)
	LDS  R30,_remaining_seconds
	LDS  R31,_remaining_seconds+1
	SBIW R30,0
	BRNE _0x6
; 0000 004A     {
; 0000 004B         if (remaining_minutes == 0)
	LDS  R30,_remaining_minutes
	LDS  R31,_remaining_minutes+1
	SBIW R30,0
	BRNE _0x7
; 0000 004C         {
; 0000 004D         LightDancer(); sound_buzzer();
	RCALL _LightDancer
	RCALL _sound_buzzer
; 0000 004E         }
; 0000 004F         else
	RJMP _0x8
_0x7:
; 0000 0050         {
; 0000 0051         remaining_seconds = 59;
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	STS  _remaining_seconds,R30
	STS  _remaining_seconds+1,R31
; 0000 0052         remaining_minutes --;
	LDI  R26,LOW(_remaining_minutes)
	LDI  R27,HIGH(_remaining_minutes)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0053         }
_0x8:
; 0000 0054     }
; 0000 0055 }
_0x6:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;interrupt [TIM1_COMPB] void timer1_compb_isr(void)
; 0000 0058 {
_timer1_compb_isr:
; .FSTART _timer1_compb_isr
; 0000 0059 
; 0000 005A }
	RETI
; .FEND
;
;void main(void)
; 0000 005D {
_main:
; .FSTART _main
; 0000 005E // Declare your local variables here
; 0000 005F 
; 0000 0060 
; 0000 0061     // Set ROWS as outputs and COLS as inputs
; 0000 0062      DDRB = 0xFF; // Assuming keypad is connected to PORTB pins 0-3 as COLS
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0063 //    PORTB = 0x00; // Activate internal pull-ups on PORTB pins 0-3 as COLS
; 0000 0064      DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 0065      PORTA=(1<<PORTA7) | (1<<PORTA6) |(1<<PORTA5) |(1<<PORTA4) |(0<<PORTA3) |(0<<PORTA2) |(0<<PORTA1) | (0<<PORTA7);
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 0066      DDRC = 0xFF; // Assuming seven segment display is connected to PORTC
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0067      DDRD = 0xFF; // Assuming LEDs are connected to PORTD
	OUT  0x11,R30
; 0000 0068 
; 0000 0069 // Timer/Counter 0 initialization
; 0000 006A TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(13)
	OUT  0x33,R30
; 0000 006B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 006C OCR0=0x7C;
	LDI  R30,LOW(124)
	OUT  0x3C,R30
; 0000 006D 
; 0000 006E // Timer/Counter 1 initialization
; 0000 006F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0070 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0071 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0072 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0073 OCR1AH=0x7A;
	LDI  R30,LOW(122)
	OUT  0x2B,R30
; 0000 0074 OCR1AL=0x11;
	LDI  R30,LOW(17)
	OUT  0x2A,R30
; 0000 0075 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0076 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0077 //
; 0000 0078 //// Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0079 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (1<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(26)
	OUT  0x39,R30
; 0000 007A 
; 0000 007B 
; 0000 007C  // Read minutes input from keypad
; 0000 007D // Global enable interrupts
; 0000 007E #asm("sei")
	sei
; 0000 007F while (1)
_0x9:
; 0000 0080       {
; 0000 0081       // Place your code here
; 0000 0082        key = read_keypad();
	RCALL _read_keypad
	MOV  R11,R30
; 0000 0083        getval(key);
	MOV  R26,R11
	RCALL _getval
; 0000 0084        display_on_seven_segment_second(remaining_seconds);
	LDS  R26,_remaining_seconds
	RCALL _display_on_seven_segment_second
; 0000 0085        display_on_seven_segment_minute(remaining_minutes);
	LDS  R26,_remaining_minutes
	RCALL _display_on_seven_segment_minute
; 0000 0086       }
	RJMP _0x9
; 0000 0087 }
_0xC:
	RJMP _0xC
; .FEND
;
;
;void blink_segment(char mode)
; 0000 008B {
; 0000 008C  switch (mode)
;	mode -> Y+0
; 0000 008D  {
; 0000 008E  //PORTC = 0xFE;
; 0000 008F   case 1:
; 0000 0090   PORTC = ~(segments[digit[i]]);
; 0000 0091   case 2:
; 0000 0092   PIND.1=0;
; 0000 0093 
; 0000 0094  }
; 0000 0095 }
;
;
;
;void display_on_seven_segment_minute(char minute) {
; 0000 0099 void display_on_seven_segment_minute(char minute) {
_display_on_seven_segment_minute:
; .FSTART _display_on_seven_segment_minute
; 0000 009A 
; 0000 009B     // Extract digits from the number
; 0000 009C      digit[1] = minute % 10;
	RCALL SUBOPT_0x0
;	minute -> Y+0
	__PUTW1MN _digit,2
; 0000 009D      digit[0] = minute / 10;
	RCALL SUBOPT_0x1
	STS  _digit,R30
	STS  _digit+1,R31
; 0000 009E }
	RJMP _0x2000001
; .FEND
;void display_on_seven_segment_second(char second) {
; 0000 009F void display_on_seven_segment_second(char second) {
_display_on_seven_segment_second:
; .FSTART _display_on_seven_segment_second
; 0000 00A0 
; 0000 00A1     // Extract digits from the number
; 0000 00A2      digit[3] = second % 10;
	RCALL SUBOPT_0x0
;	second -> Y+0
	__PUTW1MN _digit,6
; 0000 00A3      digit[2] = second / 10;
	RCALL SUBOPT_0x1
	__PUTW1MN _digit,4
; 0000 00A4 }
	RJMP _0x2000001
; .FEND
;
;
;    char read_keypad() {
; 0000 00A7 char read_keypad() {
_read_keypad:
; .FSTART _read_keypad
; 0000 00A8 
; 0000 00A9    // Loop through each ROW and check for key press
; 0000 00AA     PORTA.0=0;PORTA.1=1;PORTA.2=1;PORTA.3=1;
	CBI  0x1B,0
	SBI  0x1B,1
	SBI  0x1B,2
	SBI  0x1B,3
; 0000 00AB     if(!PINA.4) return keys[0];
	SBIC 0x19,4
	RJMP _0x1D
	LDS  R30,_keys
	RET
; 0000 00AC     if(!PINA.5) return keys[1];
_0x1D:
	SBIC 0x19,5
	RJMP _0x1E
	__GETB1MN _keys,1
	RET
; 0000 00AD     if(!PINA.6) return keys[2];
_0x1E:
	SBIC 0x19,6
	RJMP _0x1F
	__GETB1MN _keys,2
	RET
; 0000 00AE     if(!PINA.7) return keys[3];
_0x1F:
	SBIC 0x19,7
	RJMP _0x20
	__GETB1MN _keys,3
	RET
; 0000 00AF     PORTA.0=1;PORTA.1=0;PORTA.2=1;PORTA.3=1;
_0x20:
	SBI  0x1B,0
	CBI  0x1B,1
	SBI  0x1B,2
	SBI  0x1B,3
; 0000 00B0     if(!PINA.4) return keys[4];
	SBIC 0x19,4
	RJMP _0x29
	__GETB1MN _keys,4
	RET
; 0000 00B1     if(!PINA.5) return keys[5];
_0x29:
	SBIC 0x19,5
	RJMP _0x2A
	__GETB1MN _keys,5
	RET
; 0000 00B2     if(!PINA.6) return keys[6];
_0x2A:
	SBIC 0x19,6
	RJMP _0x2B
	__GETB1MN _keys,6
	RET
; 0000 00B3     if(!PINA.7) return keys[7];
_0x2B:
	SBIC 0x19,7
	RJMP _0x2C
	__GETB1MN _keys,7
	RET
; 0000 00B4     PORTA.0=1;PORTA.1=1;PORTA.2=0;PORTA.3=1;
_0x2C:
	SBI  0x1B,0
	SBI  0x1B,1
	CBI  0x1B,2
	SBI  0x1B,3
; 0000 00B5     if(!PINA.4) return keys[8];
	SBIC 0x19,4
	RJMP _0x35
	__GETB1MN _keys,8
	RET
; 0000 00B6     if(!PINA.5) return keys[9];
_0x35:
	SBIC 0x19,5
	RJMP _0x36
	__GETB1MN _keys,9
	RET
; 0000 00B7     if(!PINA.6) return keys[10];
_0x36:
	SBIC 0x19,6
	RJMP _0x37
	__GETB1MN _keys,10
	RET
; 0000 00B8     if(!PINA.7) return keys[11];
_0x37:
	SBIC 0x19,7
	RJMP _0x38
	__GETB1MN _keys,11
	RET
; 0000 00B9     PORTA.0=1;PORTA.1=1;PORTA.2=1;PORTA.3=0;
_0x38:
	SBI  0x1B,0
	SBI  0x1B,1
	SBI  0x1B,2
	CBI  0x1B,3
; 0000 00BA     if(!PINA.4) return keys[12];
	SBIC 0x19,4
	RJMP _0x41
	__GETB1MN _keys,12
	RET
; 0000 00BB     if(!PINA.5) return keys[13];
_0x41:
	SBIC 0x19,5
	RJMP _0x42
	__GETB1MN _keys,13
	RET
; 0000 00BC     if(!PINA.6) return keys[14];
_0x42:
	SBIC 0x19,6
	RJMP _0x43
	__GETB1MN _keys,14
	RET
; 0000 00BD     if(!PINA.7) return keys[15];
_0x43:
	SBIC 0x19,7
	RJMP _0x44
	__GETB1MN _keys,15
	RET
; 0000 00BE     return 16;
_0x44:
	LDI  R30,LOW(16)
	RET
; 0000 00BF 
; 0000 00C0     }
; .FEND
;    int getval(char key)
; 0000 00C2     {
_getval:
; .FSTART _getval
; 0000 00C3         if (key != 16)  //if any key was pressed
	ST   -Y,R26
;	key -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x10)
	BRNE PC+2
	RJMP _0x45
; 0000 00C4        {
; 0000 00C5        while(1)
_0x46:
; 0000 00C6        {
; 0000 00C7         if (remaining_seconds)
	LDS  R30,_remaining_seconds
	LDS  R31,_remaining_seconds+1
	SBIW R30,0
	BREQ _0x49
; 0000 00C8         {
; 0000 00C9          if ( key == 'c')
	LD   R26,Y
	CPI  R26,LOW(0x63)
	BRNE _0x4A
; 0000 00CA          {
; 0000 00CB 
; 0000 00CC            TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 00CD            break;
	RJMP _0x48
; 0000 00CE          }
; 0000 00CF         }
_0x4A:
; 0000 00D0 
; 0000 00D1         if( key == '=')
_0x49:
	LD   R26,Y
	CPI  R26,LOW(0x3D)
	BRNE _0x4B
; 0000 00D2            {
; 0000 00D3                 seconds = digit2;
	MOV  R30,R8
	LDI  R31,0
	STS  _seconds,R30
	STS  _seconds+1,R31
; 0000 00D4                 remaining_seconds= seconds;
	STS  _remaining_seconds,R30
	STS  _remaining_seconds+1,R31
; 0000 00D5                 digit1 =0;
	CLR  R9
; 0000 00D6                 break;
	RJMP _0x48
; 0000 00D7            }
; 0000 00D8             if ( key == '+')        //if + was entered
_0x4B:
	LD   R26,Y
	CPI  R26,LOW(0x2B)
	BRNE _0x4C
; 0000 00D9            {
; 0000 00DA             minutes= digit2;
	MOV  R12,R8
	CLR  R13
; 0000 00DB             remaining_minutes= minutes;
	__PUTWMRN _remaining_minutes,0,12,13
; 0000 00DC             digit1=0;
	CLR  R9
; 0000 00DD             break;
	RJMP _0x48
; 0000 00DE             }
; 0000 00DF             if (digit1 || flag)
_0x4C:
	TST  R9
	BRNE _0x4E
	TST  R10
	BREQ _0x4D
_0x4E:
; 0000 00E0             {
; 0000 00E1              digit2 = (digit1 *10) + key - '0';
	MOV  R30,R9
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	LD   R26,Y
	ADD  R26,R30
	SUBI R26,LOW(48)
	MOV  R8,R26
; 0000 00E2              break;
	RJMP _0x48
; 0000 00E3             }
; 0000 00E4 
; 0000 00E5 
; 0000 00E6           if ( (key >= '0') && (key<= '9') )
_0x4D:
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRLO _0x51
	CPI  R26,LOW(0x3A)
	BRLO _0x52
_0x51:
	RJMP _0x50
_0x52:
; 0000 00E7            {
; 0000 00E8             digit1 = key - '0';
	LD   R30,Y
	SUBI R30,LOW(48)
	MOV  R9,R30
; 0000 00E9             if (digit1 ==0) flag = 1;
	TST  R9
	BRNE _0x53
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 00EA             return digit1;
_0x53:
	MOV  R30,R9
	LDI  R31,0
	RJMP _0x2000001
; 0000 00EB            }
; 0000 00EC        }
_0x50:
	RJMP _0x46
_0x48:
; 0000 00ED 
; 0000 00EE 
; 0000 00EF       }
; 0000 00F0     }
_0x45:
_0x2000001:
	ADIW R28,1
	RET
; .FEND
;
;    	void LightDancer()
; 0000 00F3 	{
_LightDancer:
; .FSTART _LightDancer
; 0000 00F4 		int a;
; 0000 00F5 		char led[]=
; 0000 00F6          {
; 0000 00F7 			0b11111111,
; 0000 00F8 			0b11100111,
; 0000 00F9 			0b11000011,
; 0000 00FA 			0b10000001,
; 0000 00FB 			0b00000000,
; 0000 00FC          };
; 0000 00FD 
; 0000 00FE 		for (a=0;a<=5;a++)
	SBIW R28,5
	LDI  R30,LOW(255)
	ST   Y,R30
	LDI  R30,LOW(231)
	STD  Y+1,R30
	LDI  R30,LOW(195)
	STD  Y+2,R30
	LDI  R30,LOW(129)
	STD  Y+3,R30
	LDI  R30,LOW(0)
	STD  Y+4,R30
	ST   -Y,R17
	ST   -Y,R16
;	a -> R16,R17
;	led -> Y+2
	__GETWRN 16,17,0
_0x55:
	__CPWRN 16,17,6
	BRGE _0x56
; 0000 00FF 		{
; 0000 0100 			PORTB=led[a];
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	OUT  0x18,R30
; 0000 0101 			delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0102 		};
	__ADDWRN 16,17,1
	RJMP _0x55
_0x56:
; 0000 0103         for (a=4;a>=0;a--)
	__GETWRN 16,17,4
_0x58:
	TST  R17
	BRMI _0x59
; 0000 0104 		{
; 0000 0105 			PORTB= ~(led[a]);
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	COM  R30
	OUT  0x18,R30
; 0000 0106 			delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0107 		}
	__SUBWRN 16,17,1
	RJMP _0x58
_0x59:
; 0000 0108 	}
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
; .FEND
;
;    void sound_buzzer()
; 0000 010B {
_sound_buzzer:
; .FSTART _sound_buzzer
; 0000 010C     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 010D     PIND.5 = 1;
	RCALL SUBOPT_0x2
; 0000 010E     delay_ms(500);
; 0000 010F     PIND.5 = 0;
; 0000 0110     PIND.5 = 1;
	RCALL SUBOPT_0x2
; 0000 0111     delay_ms(500);
; 0000 0112     PIND.5 = 0;
; 0000 0113 }
	RET
; .FEND
;
;
;

	.DSEG
_digit:
	.BYTE 0x8
_seconds:
	.BYTE 0x2
_remaining_seconds:
	.BYTE 0x2
_remaining_minutes:
	.BYTE 0x2
_keys:
	.BYTE 0x10

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	LD   R26,Y
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LD   R26,Y
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	SBI  0x10,5
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	CBI  0x10,5
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
