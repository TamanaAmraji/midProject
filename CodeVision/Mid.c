#include <mega32.h>
#include <delay.h>
// Declare your global variables here
int LCD_ref=0x01, i=0, digit[4];       
unsigned char digit1=0,digit2= 0, key, flag;
   int minutes = 0,seconds = 0,remaining_seconds, remaining_minutes, mode = 1;          
#define col0    PINA.0
#define col1    PINA.1
#define col2    PINA.2
#define col3    PINA.3 
#define Buzzer  PIND.6 
#define LED_PORT PORTB

    const int segments[] =
     {
        0x40, // 0
        0x79, // 1
        0x24, // 2
        0x30, // 3
        0x19, // 4
        0x12, // 5
        0x02, // 6
        0x78, // 7
        0x00, // 8
        0x10 // 9  
    };  
    
    char keys[]= {                      //based on keypad model we use in proteus
              '7', '8', '9', '/',
              '4', '5', '6', 'x',
              '1', '2', '3', '-',
              'c', '0', '=', '+'
              };   
//              
//   char keys[]= {                       //based on keypad model we use in Lab
//              '/','1', '2', '3',
//              '+','4', '5', '6',
//              '-','7', '8', '9',
//              'x','c', '0', '='
//              };
////    
//char ref[]= {0xF7,0xF6,0xFB,0xF7};  

// Function prototypes
void display_on_seven_segment_minute(char minute);
void display_on_seven_segment_second(char second);
char read_keypad();
int getval(char key);
void Ready_segment(int on);
void LightDancer();
void sound_buzzer(); 
void Finish();


interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
 //Place your code here 
     
    PORTD = (LCD_ref); 
    PORTC = (segments[digit[i]]);      
    LCD_ref = LCD_ref<<1; 
    i++;    
    if (i == 4) 
    {
        i = 0;
        LCD_ref = 0x01;
    }   

}

interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{ 
    if (remaining_seconds == 0) 
    {  
        if (remaining_minutes == 0) 
        {  
            Finish();
        } 
        else 
        {
            remaining_seconds = 59;
            remaining_minutes --;
        }
    }
    else     remaining_seconds--;
}

interrupt [TIM1_COMPB] void timer1_compb_isr(void)
{
   
}

void main(void)
{

// Set ROWS as outputs and COLS as inputs
DDRB = 0xFF; // Assuming led connected to PORTB pins 0-3 as COLS   
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0); 
PORTA=(1<<PORTA7) | (1<<PORTA6) |(1<<PORTA5) |(1<<PORTA4) |(0<<PORTA3) |(0<<PORTA2) |(0<<PORTA1) | (0<<PORTA7);      
DDRC = 0xFF; // Assuming seven segment display is connected to PORTC  
DDRD = 0xFF;   

// Timer/Counter 0 initialization
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x63;

// Timer/Counter 1 initialization
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x7A;
OCR1AL=0x11;
OCR1BH=0x00;
OCR1BL=0x00;
//
//// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (1<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);
     
// Global enable interrupts
#asm("sei")
while (1)
      {  
      // Place your code here 
       key = read_keypad();  
       getval(key); 
       display_on_seven_segment_second(remaining_seconds);  
       display_on_seven_segment_minute(remaining_minutes);
      }
}

//FUNCTIONS
    void Ready_segment(int on)
    {  
       if (on == 1)
       {
           TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00); 
           PORTD = (LCD_ref);
           PORTC = (0x40);
           delay_ms(150);
           PORTD = (LCD_ref);     
           LCD_ref = LCD_ref<<1; 
           i++;    
           if (i == 4) 
           {
            i = 0;
            LCD_ref = 0x01;
           }
       }  
       else if (on == 0) 
       {
        TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00); 
       }  
    }
    
    void display_on_seven_segment_minute(char minute) 
    {     
        // Extract digits from the number
         digit[1] = minute % 10; 
         digit[0] = minute / 10;            
    }
    void display_on_seven_segment_second(char second)
     {     
        // Extract digits from the number
         digit[3] = second % 10;
         digit[2] = second / 10;            
    }

    char read_keypad() {
   // Loop through each ROW and check for key press    
        PORTA.0=0;PORTA.1=1;PORTA.2=1;PORTA.3=1;   
        if(!PINA.4) return keys[0];
        if(!PINA.5) return keys[1];
        if(!PINA.6) return keys[2]; 
        if(!PINA.7) return keys[3];
        PORTA.0=1;PORTA.1=0;PORTA.2=1;PORTA.3=1;  
        if(!PINA.4) return keys[4];
        if(!PINA.5) return keys[5];
        if(!PINA.6) return keys[6];
        if(!PINA.7) return keys[7];
        PORTA.0=1;PORTA.1=1;PORTA.2=0;PORTA.3=1;  
        if(!PINA.4) return keys[8];
        if(!PINA.5) return keys[9];
        if(!PINA.6) return keys[10];
        if(!PINA.7) return keys[11];
        PORTA.0=1;PORTA.1=1;PORTA.2=1;PORTA.3=0; 
        if(!PINA.4) return keys[12];
        if(!PINA.5) return keys[13];
        if(!PINA.6) return keys[14]; 
        if(!PINA.7) return keys[15];
        return 16; 
    }
    
    int getval(char key)
    {      
        if (key != 16)  //if any key was pressed 
       { 
       mode = 0; 
       while(1)
       {
        if (key == '-')
        {
         remaining_minutes=0;
         remaining_seconds=0; 
         break;
        }  
        if (remaining_seconds) 
            {
             if ( key == 'c') 
             {     
                   LED_PORT = 0x00;
                   TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10); 
                   break;
             }
        }

        if( key == '=')
        {  
            seconds = digit2;
            remaining_seconds= seconds;
            digit1 =0;
            LED_PORT = 0x55;; 
            break;
        } 
        if ( key == '+')        //if + was entered 
        {                
            minutes= digit2;     
            if (minutes > 59) remaining_minutes = 59;
            remaining_minutes= minutes;  
            digit1=0; 
            LED_PORT = ~(0x55);        
            break; 
        } 
        if (digit1 || flag)
        {     
            if (flag ==1) 
            {
                digit2 = /*(digit1 *10) +*/ key - '0'; 
                flag =0;
                break; 
            }
            else 
            { 
                digit2 = (digit1 *10) + key - '0';
                break;
            }
             
            break;
        }
        if ( (key >= '0') && (key<= '9') )
        {  
            digit1 = key - '0';
            if (digit1 ==0) flag = 1;
            return digit1;   
        }    
       } 
      }
      Ready_segment(mode);   
    } 
    
    void LightDancer()
	{
		int a;
		char led[]=
         {
			0b11111111,
			0b11100111,
			0b11000011,
			0b10000001,
			0b00000000,
         };
				
		for (a=0;a<=5;a++)
		{
			PORTB=led[a];
			delay_ms(100);
		}; 
        for (a=4;a>=0;a--)
		{
			LED_PORT= ~(led[a]);
			delay_ms(100);
		}
	}  
    
    void sound_buzzer() 
    {
        PORTD = 0xFF;
//        delay_ms(500); 
//        PORTD = 0;    
//        delay_ms(500); 
//        PORTD = 1; 
//        delay_ms(500); 
//        PORTD = 0; 
    }
     
    void Finish()
    {
     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10); 
     sound_buzzer();
     LightDancer();
     PORTC = 0x40; 
     PORTD = 0x0F; 
     mode = 1;
    }
       
    



