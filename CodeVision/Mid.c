/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 5/27/2024
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>

// Declare your global variables here
int seg[]={0x40,0x79,0x24,0x30,0x19,0x12,0x02,0x78,0x00,0x10}; 
//int seg[]={0x78,0x00,0x10,0,0x19,0x12,0x02,0,0x79,0x24,0x30,0,0,0x40,0,0};  //7,8,9,/,4,5,6,x,1,2,3,-,c,0,=,+
char out;
char determine();
int input=0;
char ref[]= {
            0b00000001,
            0b00000010,
            0b00000100,
            0b00001000
            };                      //for refreshing rows
char keys[]= {                      //based on keypad model we use
              '/', '9', '8', '7',
              'x', '6', '5', '4',
              '-', '3', '2', '1',
              '+', '=', '0', 'c'
              };
char keypad();
int LightDancer();

#define col0    PINB.0
#define col1    PINB.1
#define col2    PINB.2
#define col3    PINB.3  
            
// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Reinitialize Timer1 value
TCNT1H=0x85EE >> 8;
TCNT1L=0x85EE & 0xff;
// Place your code here
}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here

}

// Timer1 output compare B interrupt service routine
interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
// Place your code here

}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0xB2;
// Place your code here

}
// Timer2 output compare interrupt service routine
interrupt [TIM2_COMP] void timer2_comp_isr(void)     //segment refresh
{
// Place your code here  
     
}   
void main(void)
{
// Declare your local variables here
int b=0;
// Input/Output Ports initialization

// Function: PORT A,C,D : output, pulldown
DDRA= 0xFF;     DDRC=0xFF;      DDRD=0xFF;
PORTA= 0x00;    PORTC= 0x00;    PORTD=0x00; 

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Oin Bit2=in Bit1=in Bit0=in 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=1 Bit3=1 Bit2=1 Bit1=1 Bit0=1 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);


// Timer/Counter 1 initialization
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x85;
TCNT1L=0xEE;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x7A;
OCR1AL=0x11;
OCR1BH=0x00;
OCR1BL=0x00;


// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: CTC top=OCR2A
// OC2 output: Disconnected
// Timer Period: 0.128 ms
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (1<<CTC2) | (1<<CS22) | (1<<CS21) | (1<<CS20);
TCNT2=0xB2;
OCR2=0x4D;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(1<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (1<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);


// Global enable interrupts
#asm("sei")

while (1)
      {       
      // Place your code here 
      out   = keypad();  
      PORTC = ~seg [out];
//      LightDancer();
      }
}

//	int LightDancer()
//	{
//		int a;
//		char led[]= {
//			0b10000000,
//			0b01000000,
//			0b00100000,
//			0b00010000,
//			0b00001000,
//			0b00000100,
//			0b00000010,
//			0b00000001};
//				
//		for (a=0;a<=7;a++)
//		{
//			PORTB=led[a];
//			delay_ms(100);
//		};
//		for (a=6;a>=0;a--)
//		{
//			PORTC=led[a];
//			delay_ms(100);
//		};
//	}  
    
    char keypad()
    {
        while(1)
        {
           int row=0, col=-1,val=-2;
           for (row = 0; row<4; row++)
           {
           PORTA = ~ref[row];
              if(col0 == 0)
               {  
                  while(col0 == 0);
                  col = 0;  
                  break;                      
               }  
              if(col1 == 0)
               { 
                  while(col1 == 0);
                  col = 1;
                  break;   
               } 
               if(col2 == 0)
               {
                  while(col2 == 0);
                  col = 2;
                  break;
               }
              if(col3 == 0)
               {
                  while(col3 == 0);
                  col = 3;
                  break;
               } 
              }  
               if (col != -1) //if key was pressed
               {
                 val= row*4 + col;     
//                if (val != 0 && val != 1 && val != 3 && val != 4 && val != 8 && val != 12)
//                {
//                   PORTC = ~seg [(row-1)*3 - (col-1)]; 
//                }     
                //PORTC = ~seg [val]; 
                PIND.0 = 1;   
                
                switch (val) {
                case 0: 
                    input  = 7;
                break; 
                case 1: 
                    input  = 8;
                break; 
                case 2: 
                    input  = 9;
                break;
                case 4: 
                    input  = 4;
                break; 
                case 5: 
                    input  = 5;
                break;    
                case 6: 
                    input  = 6; 
                break;
                case 8: 
                    input  = 1;     
                break; 
                case 9: 
                    input  = 2;
                break; 
                case 10: 
                    input  = 3;
                break;    
                case 12: 
                    input  = 0;
                break;
               }  
               
               return input;

        }
    } 
}
    
//   void detrmine(int c)
//    {  int input = 0;
//        switch (c) {
//        case 0: 
//            input  = 7;
//        break; 
//        case 1: 
//            input  = 8;
//        break; 
//        case 2: 
//            input  = 9;
//        break;
//        case 4: 
//            input  = 4;
//        break; 
//        case 5: 
//            input  = 5;
//        break;    
//        case 6: 
//            input  = 6; 
//        break;
//        case 8: 
//            input  = 1;     
//        break; 
//        case 9: 
//            input  = 2;
//        break; 
//        case 10: 
//            input  = 3;
//        break;    
//        case 12: 
//            input  = 0;
//        break;
//        return input;
//        };
//    }