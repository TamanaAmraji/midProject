
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
	.DEF _row=R8
	.DEF _row_msb=R9
	.DEF _col=R10
	.DEF _col_msb=R11
	.DEF _input=R12
	.DEF _input_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
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
	.DB  0xEF,0x0,0x0,0x0
	.DB  0xFF,0xFF,0xFF,0xFF
	.DB  0xFF,0xFF

_0x3:
	.DB  0x1,0x2,0x4,0x8
_0xC7:
	.DB  0x40,0x0,0x79,0x0,0x24,0x0,0x30,0x0
	.DB  0x19,0x0,0x12,0x0,0x2,0x0,0x78,0x0
	.DB  0x0,0x0,0x10,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

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
;int LCD_ref=0xEF, i=0, digit[2];
;    int row = -1, col =-1, input = -1;
;#define col0    PINA.4
;#define col1    PINA.5
;#define col2    PINA.6
;#define col3    PINA.7
;
;    const int segments[] =
;     {
;        // 0bGFEDCBA
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
;    char row_ref[]= {
;            0b00000001,
;            0b00000010,
;            0b00000100,
;            0b00001000
;            };

	.DSEG
;
;// Function prototypes
;void display_on_seven_segment(int number);
;//int read_keypad();
;// Timer 0 output compare interrupt service routine
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 0026 {

	.CSEG
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0027 // Place your code here
; 0000 0028 //    PORTB = LCD_ref;
; 0000 0029 //    LCD_ref = LCD_ref<<1;
; 0000 002A //    i++;
; 0000 002B //    if (i == 4)
; 0000 002C //    {
; 0000 002D //        i = 0;
; 0000 002E //        LCD_ref = 0xEF;
; 0000 002F //    }
; 0000 0030 //
; 0000 0031 
; 0000 0032      // while(1){
; 0000 0033         PINA.0=0;PINA.1=1;PINA.2=1;PINA.3=1;
	CBI  0x19,0
	SBI  0x19,1
	SBI  0x19,2
	SBI  0x19,3
; 0000 0034               if(col0 == 0)
	SBIC 0x19,4
	RJMP _0xC
; 0000 0035                {
; 0000 0036                   while(col0 == 0);
_0xD:
	SBIS 0x19,4
	RJMP _0xD
; 0000 0037                   input = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R12,R30
; 0000 0038                   //break;
; 0000 0039                }
; 0000 003A               if(col1 == 0)
_0xC:
	SBIC 0x19,5
	RJMP _0x10
; 0000 003B                {
; 0000 003C                   while(col1 == 0);
_0x11:
	SBIS 0x19,5
	RJMP _0x11
; 0000 003D                   input = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R12,R30
; 0000 003E                   //break;
; 0000 003F                }
; 0000 0040                if(col2 == 0)
_0x10:
	SBIC 0x19,6
	RJMP _0x14
; 0000 0041                {
; 0000 0042                   while(col2 == 0);
_0x15:
	SBIS 0x19,6
	RJMP _0x15
; 0000 0043                   input = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R12,R30
; 0000 0044                //   break;
; 0000 0045                }
; 0000 0046               if(col3 == 0)
_0x14:
	SBIC 0x19,7
	RJMP _0x18
; 0000 0047                {
; 0000 0048                   while(col3 == 0);
_0x19:
	SBIS 0x19,7
	RJMP _0x19
; 0000 0049                   input = 10; // /
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R12,R30
; 0000 004A                 //  break;
; 0000 004B                }
; 0000 004C 
; 0000 004D         PINA.0=1;PINA.1=0;PINA.2=1;PINA.3=1;
_0x18:
	SBI  0x19,0
	CBI  0x19,1
	SBI  0x19,2
	SBI  0x19,3
; 0000 004E         if(col0 == 0)
	SBIC 0x19,4
	RJMP _0x24
; 0000 004F                {
; 0000 0050                   while(col0 == 0);
_0x25:
	SBIS 0x19,4
	RJMP _0x25
; 0000 0051                   input = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R12,R30
; 0000 0052                 //  break;
; 0000 0053                }
; 0000 0054               if(col1 == 0)
_0x24:
	SBIC 0x19,5
	RJMP _0x28
; 0000 0055                {
; 0000 0056                   while(col1 == 0);
_0x29:
	SBIS 0x19,5
	RJMP _0x29
; 0000 0057                   input = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R12,R30
; 0000 0058                 //  break;
; 0000 0059                }
; 0000 005A                if(col2 == 0)
_0x28:
	SBIC 0x19,6
	RJMP _0x2C
; 0000 005B                {
; 0000 005C                   while(col2 == 0);
_0x2D:
	SBIS 0x19,6
	RJMP _0x2D
; 0000 005D                   PORTC= ~(0x02);
	LDI  R30,LOW(253)
	OUT  0x15,R30
; 0000 005E                   //input = 6;
; 0000 005F                 //  break;
; 0000 0060                }
; 0000 0061               if(col3 == 0)
_0x2C:
	SBIC 0x19,7
	RJMP _0x30
; 0000 0062                {
; 0000 0063                   while(col3 == 0);
_0x31:
	SBIS 0x19,7
	RJMP _0x31
; 0000 0064                   input = 11; // x
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R12,R30
; 0000 0065                 //  break;
; 0000 0066                }
; 0000 0067 
; 0000 0068         PINA.0=1;PINA.1=1;PINA.2=0;PINA.3=1;
_0x30:
	SBI  0x19,0
	SBI  0x19,1
	CBI  0x19,2
	SBI  0x19,3
; 0000 0069         if(col0 == 0)
	SBIC 0x19,4
	RJMP _0x3C
; 0000 006A                {
; 0000 006B                   while(col0 == 0);
_0x3D:
	SBIS 0x19,4
	RJMP _0x3D
; 0000 006C                   input = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 006D                 //  break;
; 0000 006E                }
; 0000 006F               if(col1 == 0)
_0x3C:
	SBIC 0x19,5
	RJMP _0x40
; 0000 0070                {
; 0000 0071                   while(col1 == 0);
_0x41:
	SBIS 0x19,5
	RJMP _0x41
; 0000 0072                   input = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 0073                //   break;
; 0000 0074                }
; 0000 0075                if(col2 == 0)
_0x40:
	SBIC 0x19,6
	RJMP _0x44
; 0000 0076                {
; 0000 0077                   while(col2 == 0);
_0x45:
	SBIS 0x19,6
	RJMP _0x45
; 0000 0078                   input = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R12,R30
; 0000 0079                //   break;
; 0000 007A                }
; 0000 007B               if(col3 == 0)
_0x44:
	SBIC 0x19,7
	RJMP _0x48
; 0000 007C                {
; 0000 007D                   while(col3 == 0);
_0x49:
	SBIS 0x19,7
	RJMP _0x49
; 0000 007E                   input = 12; // -
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	MOVW R12,R30
; 0000 007F                //   break;
; 0000 0080                }
; 0000 0081 
; 0000 0082         PINA.0=1;PINA.1=1;PINA.2=1;PINA.3=0;
_0x48:
	SBI  0x19,0
	SBI  0x19,1
	SBI  0x19,2
	CBI  0x19,3
; 0000 0083         if(col0 == 0)
	SBIC 0x19,4
	RJMP _0x54
; 0000 0084                {
; 0000 0085                   while(col0 == 0);
_0x55:
	SBIS 0x19,4
	RJMP _0x55
; 0000 0086                   input = 13; // C/ON
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	MOVW R12,R30
; 0000 0087                 //  break;
; 0000 0088                }
; 0000 0089               if(col1 == 0)
_0x54:
	SBIC 0x19,5
	RJMP _0x58
; 0000 008A                {
; 0000 008B                   while(col1 == 0);
_0x59:
	SBIS 0x19,5
	RJMP _0x59
; 0000 008C                   input = 0;
	CLR  R12
	CLR  R13
; 0000 008D                 //  break;
; 0000 008E                }
; 0000 008F                if(col2 == 0)
_0x58:
	SBIC 0x19,6
	RJMP _0x5C
; 0000 0090                {
; 0000 0091                   while(col2 == 0);
_0x5D:
	SBIS 0x19,6
	RJMP _0x5D
; 0000 0092                   input = 14;  //=
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	MOVW R12,R30
; 0000 0093                 //  break;
; 0000 0094                }
; 0000 0095               if(col3 == 0)
_0x5C:
	SBIC 0x19,7
	RJMP _0x60
; 0000 0096                {
; 0000 0097                   while(col3 == 0);
_0x61:
	SBIS 0x19,7
	RJMP _0x61
; 0000 0098                   input = 15; // +
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R12,R30
; 0000 0099                //   break;
; 0000 009A                }
; 0000 009B              // }
; 0000 009C 
; 0000 009D 
; 0000 009E }
_0x60:
	RJMP _0xC8
; .FEND
;
;// Timer2 output compare interrupt service routine
;interrupt [TIM2_COMP] void timer2_comp_isr(void)     //segment refresh
; 0000 00A2 {
_timer2_comp_isr:
; .FSTART _timer2_comp_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A3 // Place your code here
; 0000 00A4 
; 0000 00A5   PINA.0=1;
	SBI  0x19,0
; 0000 00A6     while(1){
_0x66:
; 0000 00A7         PINA.0=0;PINA.1=1;PINA.2=1;PINA.3=1;
	CBI  0x19,0
	SBI  0x19,1
	SBI  0x19,2
	SBI  0x19,3
; 0000 00A8               if(col0 == 0)
	SBIC 0x19,4
	RJMP _0x71
; 0000 00A9                {
; 0000 00AA                   //while(col0 == 0);
; 0000 00AB                   input = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	MOVW R12,R30
; 0000 00AC                   //break;
; 0000 00AD                }
; 0000 00AE               if(col1 == 0)
_0x71:
	SBIC 0x19,5
	RJMP _0x72
; 0000 00AF                {
; 0000 00B0                   //while(col1 == 0);
; 0000 00B1                   input = 8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	MOVW R12,R30
; 0000 00B2                   //break;
; 0000 00B3                }
; 0000 00B4                if(col2 == 0)
_0x72:
	SBIC 0x19,6
	RJMP _0x73
; 0000 00B5                {
; 0000 00B6                   while(col2 == 0);
_0x74:
	SBIS 0x19,6
	RJMP _0x74
; 0000 00B7                   input = 9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	MOVW R12,R30
; 0000 00B8                   break;
	RJMP _0x68
; 0000 00B9                }
; 0000 00BA               if(col3 == 0)
_0x73:
	SBIC 0x19,7
	RJMP _0x77
; 0000 00BB                {
; 0000 00BC                   while(col3 == 0);
_0x78:
	SBIS 0x19,7
	RJMP _0x78
; 0000 00BD                   input = 10; // /
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MOVW R12,R30
; 0000 00BE                   break;
	RJMP _0x68
; 0000 00BF                }
; 0000 00C0 
; 0000 00C1         PINA.0=1;PINA.1=0;PINA.2=1;PINA.3=1;
_0x77:
	SBI  0x19,0
	CBI  0x19,1
	SBI  0x19,2
	SBI  0x19,3
; 0000 00C2         if(col0 == 0)
	SBIC 0x19,4
	RJMP _0x83
; 0000 00C3                {
; 0000 00C4                   while(col0 == 0);
_0x84:
	SBIS 0x19,4
	RJMP _0x84
; 0000 00C5                   input = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R12,R30
; 0000 00C6                   break;
	RJMP _0x68
; 0000 00C7                }
; 0000 00C8               if(col1 == 0)
_0x83:
	SBIC 0x19,5
	RJMP _0x87
; 0000 00C9                {
; 0000 00CA                   while(col1 == 0);
_0x88:
	SBIS 0x19,5
	RJMP _0x88
; 0000 00CB                   input = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R12,R30
; 0000 00CC                   break;
	RJMP _0x68
; 0000 00CD                }
; 0000 00CE                if(col2 == 0)
_0x87:
	SBIC 0x19,6
	RJMP _0x8B
; 0000 00CF                {
; 0000 00D0                   while(col2 == 0);
_0x8C:
	SBIS 0x19,6
	RJMP _0x8C
; 0000 00D1                   PORTC= ~(0x02);
	LDI  R30,LOW(253)
	OUT  0x15,R30
; 0000 00D2                   //input = 6;
; 0000 00D3                   break;
	RJMP _0x68
; 0000 00D4                }
; 0000 00D5               if(col3 == 0)
_0x8B:
	SBIC 0x19,7
	RJMP _0x8F
; 0000 00D6                {
; 0000 00D7                   while(col3 == 0);
_0x90:
	SBIS 0x19,7
	RJMP _0x90
; 0000 00D8                   input = 11; // x
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	MOVW R12,R30
; 0000 00D9                   break;
	RJMP _0x68
; 0000 00DA                }
; 0000 00DB 
; 0000 00DC         PINA.0=1;PINA.1=1;PINA.2=0;PINA.3=1;
_0x8F:
	SBI  0x19,0
	SBI  0x19,1
	CBI  0x19,2
	SBI  0x19,3
; 0000 00DD         if(col0 == 0)
	SBIC 0x19,4
	RJMP _0x9B
; 0000 00DE                {
; 0000 00DF                   while(col0 == 0);
_0x9C:
	SBIS 0x19,4
	RJMP _0x9C
; 0000 00E0                   input = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 00E1                   break;
	RJMP _0x68
; 0000 00E2                }
; 0000 00E3               if(col1 == 0)
_0x9B:
	SBIC 0x19,5
	RJMP _0x9F
; 0000 00E4                {
; 0000 00E5                   while(col1 == 0);
_0xA0:
	SBIS 0x19,5
	RJMP _0xA0
; 0000 00E6                   input = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 00E7                   break;
	RJMP _0x68
; 0000 00E8                }
; 0000 00E9                if(col2 == 0)
_0x9F:
	SBIC 0x19,6
	RJMP _0xA3
; 0000 00EA                {
; 0000 00EB                   while(col2 == 0);
_0xA4:
	SBIS 0x19,6
	RJMP _0xA4
; 0000 00EC                   input = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R12,R30
; 0000 00ED                   break;
	RJMP _0x68
; 0000 00EE                }
; 0000 00EF               if(col3 == 0)
_0xA3:
	SBIC 0x19,7
	RJMP _0xA7
; 0000 00F0                {
; 0000 00F1                   while(col3 == 0);
_0xA8:
	SBIS 0x19,7
	RJMP _0xA8
; 0000 00F2                   input = 12; // -
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	MOVW R12,R30
; 0000 00F3                   break;
	RJMP _0x68
; 0000 00F4                }
; 0000 00F5 
; 0000 00F6         PINA.0=1;PINA.1=1;PINA.2=1;PINA.3=0;
_0xA7:
	SBI  0x19,0
	SBI  0x19,1
	SBI  0x19,2
	CBI  0x19,3
; 0000 00F7         if(col0 == 0)
	SBIC 0x19,4
	RJMP _0xB3
; 0000 00F8                {
; 0000 00F9                   while(col0 == 0);
_0xB4:
	SBIS 0x19,4
	RJMP _0xB4
; 0000 00FA                   input = 13; // C/ON
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	MOVW R12,R30
; 0000 00FB                   break;
	RJMP _0x68
; 0000 00FC                }
; 0000 00FD               if(col1 == 0)
_0xB3:
	SBIC 0x19,5
	RJMP _0xB7
; 0000 00FE                {
; 0000 00FF                   while(col1 == 0);
_0xB8:
	SBIS 0x19,5
	RJMP _0xB8
; 0000 0100                   input = 0;
	CLR  R12
	CLR  R13
; 0000 0101                   break;
	RJMP _0x68
; 0000 0102                }
; 0000 0103                if(col2 == 0)
_0xB7:
	SBIC 0x19,6
	RJMP _0xBB
; 0000 0104                {
; 0000 0105                   while(col2 == 0);
_0xBC:
	SBIS 0x19,6
	RJMP _0xBC
; 0000 0106                   input = 14;  //=
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	MOVW R12,R30
; 0000 0107                   break;
	RJMP _0x68
; 0000 0108                }
; 0000 0109               if(col3 == 0)
_0xBB:
	SBIC 0x19,7
	RJMP _0xBF
; 0000 010A                {
; 0000 010B                   while(col3 == 0);
_0xC0:
	SBIS 0x19,7
	RJMP _0xC0
; 0000 010C                   input = 15; // +
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	MOVW R12,R30
; 0000 010D                   break;
	RJMP _0x68
; 0000 010E                }
; 0000 010F               }
_0xBF:
	RJMP _0x66
_0x68:
; 0000 0110 
; 0000 0111 }
_0xC8:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0114 {
_main:
; .FSTART _main
; 0000 0115 // Declare your local variables here
; 0000 0116 int key;  int minutes = 0,seconds = 0;
; 0000 0117 
; 0000 0118     // Initialize ports and pins
; 0000 0119     // Configure SEVENSEG_PORT, KEYPAD_PORT, BUZZER_PORT, and LED_PORT as required
; 0000 011A 
; 0000 011B     // Set ROWS as outputs and COLS as inputs
; 0000 011C     //DDRA = 0x0F; // Assuming keypad is connected to PORTA pins 0-3 as ROWS
; 0000 011D     DDRB = 0xFF; // Assuming keypad is connected to PORTB pins 0-3 as COLS
;	key -> R16,R17
;	minutes -> R18,R19
;	seconds -> R20,R21
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 011E     PORTB = 0x00; // Activate internal pull-ups on PORTB pins 0-3 as COLS
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 011F     PORTA = 0x00; // Activate internal pull-ups on PORTA pins 0-3 as ROWS
	OUT  0x1B,R30
; 0000 0120     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 0121     DDRC = 0xFF; // Assuming seven segment display is connected to PORTC
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0122     DDRD = 0xFF; // Assuming LEDs are connected to PORTD
	OUT  0x11,R30
; 0000 0123 
; 0000 0124 
; 0000 0125 // Timer/Counter 0 initialization
; 0000 0126 // Clock source: System Clock
; 0000 0127 // Clock value: 7.813 kHz
; 0000 0128 // Mode: CTC top=OCR0
; 0000 0129 // OC0 output: Disconnected
; 0000 012A // Timer Period: 9.984 ms
; 0000 012B TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(13)
	OUT  0x33,R30
; 0000 012C TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 012D OCR0=0x4D;
	LDI  R30,LOW(77)
	OUT  0x3C,R30
; 0000 012E 
; 0000 012F // Timer/Counter 1 initialization
; 0000 0130 // Clock source: System Clock
; 0000 0131 // Clock value: 31.250 kHz
; 0000 0132 // Mode: CTC top=OCR1A
; 0000 0133 // OC1A output: Disconnected
; 0000 0134 // OC1B output: Disconnected
; 0000 0135 // Noise Canceler: Off
; 0000 0136 // Input Capture on Falling Edge
; 0000 0137 // Timer Period: 1 s
; 0000 0138 // Timer1 Overflow Interrupt: Off
; 0000 0139 // Input Capture Interrupt: Off
; 0000 013A // Compare A Match Interrupt: On
; 0000 013B // Compare B Match Interrupt: On
; 0000 013C TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 013D TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 013E TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 013F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0140 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0141 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0142 OCR1AH=0x7A;
	LDI  R30,LOW(122)
	OUT  0x2B,R30
; 0000 0143 OCR1AL=0x11;
	LDI  R30,LOW(17)
	OUT  0x2A,R30
; 0000 0144 OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0145 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0146 
; 0000 0147 // Timer/Counter 2 initialization
; 0000 0148 // Clock source: System Clock
; 0000 0149 // Clock value: 7.813 kHz
; 0000 014A // Mode: CTC top=OCR2A
; 0000 014B // OC2 output: Disconnected
; 0000 014C // Timer Period: 0.128 ms
; 0000 014D ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 014E TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
	LDI  R30,LOW(15)
	OUT  0x25,R30
; 0000 014F TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0150 OCR2=0x4D;
	LDI  R30,LOW(77)
	OUT  0x23,R30
; 0000 0151 
; 0000 0152 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0153 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (1<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(26)
	OUT  0x39,R30
; 0000 0154 
; 0000 0155 
; 0000 0156  // Read minutes input from keypad
; 0000 0157 // Global enable interrupts
; 0000 0158 #asm("sei")
	sei
; 0000 0159 while (1)
_0xC3:
; 0000 015A       {
; 0000 015B       // Place your code here
; 0000 015C 
; 0000 015D //      key = read_keypad();
; 0000 015E       PORTC=  ~(segments[input]);
	MOVW R30,R12
	LDI  R26,LOW(_segments*2)
	LDI  R27,HIGH(_segments*2)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	COM  R30
	OUT  0x15,R30
; 0000 015F       //display_on_seven_segment(key);
; 0000 0160 
; 0000 0161       }
	RJMP _0xC3
; 0000 0162 }
_0xC6:
	RJMP _0xC6
; .FEND
;
;//int read_keypad()
;//{
;//    // Read input from keypad and return the pressed key
;//    // Define keypad layout (assuming a 4x4 matrix)
;//    char keypad_layout[4][4] = {
;//        {'/', '9', '8', '7'},
;//        {'x', '6', '5', '4'},
;//        {'-', '3', '2', '1'},
;//        {'+', '=', '0', 'c'}
;//    };
;//
;//    // Loop through each ROW and check for key press
;//
;//
;//
;//    }
;   // }
;
;    // No key pressed, input = null character
;   // return '0';
;
;
;
;void display_on_seven_segment(int number) {
; 0000 017B void display_on_seven_segment(int number) {
; 0000 017C 
; 0000 017D     // Display the given number on the seven segment display
; 0000 017E     // Define the segments for each digit (assuming common cathode display)
; 0000 017F     const int segments[] =
; 0000 0180      {
; 0000 0181         // 0bGFEDCBA
; 0000 0182         0x40, // 0
; 0000 0183         0x79, // 1
; 0000 0184         0x24, // 2
; 0000 0185         0x30, // 3
; 0000 0186         0x19, // 4
; 0000 0187         0x12, // 5
; 0000 0188         0x02, // 6
; 0000 0189         0x78, // 7
; 0000 018A         0x00, // 8
; 0000 018B         0x10 // 9
; 0000 018C     };
; 0000 018D 
; 0000 018E 
; 0000 018F 
; 0000 0190     // Extract digits from the number
; 0000 0191      digit[1] = number / 10;
;	number -> Y+20
;	segments -> Y+0
; 0000 0192      digit[2] = number % 10;
; 0000 0193 
; 0000 0194      //PORTC = ~(segments[digit[i]]);
; 0000 0195 }

	.DSEG
_digit:
	.BYTE 0x4

	.CSEG

	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
