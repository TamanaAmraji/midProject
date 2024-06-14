#include <mega32.h>
#include <delay.h>
// Declare your global variables here
int LCD_ref=0x01, i=0, digit[4];       
unsigned char digit1=0,digit2= 0, key;
   int minutes = 0,seconds = 0;
#define col0    PINA.0
#define col1    PINA.1
#define col2    PINA.2
#define col3    PINA.3  

    const int segments[] =
     {
        // 0bGFEDCBA
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
    
    char keys[]= {                      //based on keypad model we use
              '7', '8', '9', '/',
              '4', '5', '6', 'x',
              '1', '2', '3', '-',
              'c', '0', '=', '+'
              };
    
//char ref[]= {0xF7,0xF6,0xFB,0xF7};  

// Function prototypes
void display_on_seven_segment_minute(char minute);
void display_on_seven_segment_second(char second);
char read_keypad();
int getval(char key);
void blink_segment_minute(char mode);

interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
 //Place your code here 
     
    PORTD = ~(LCD_ref); 
    PORTC = ~(segments[digit[i]]);      
    LCD_ref = LCD_ref<<1; 
    i++;    
    if (i == 4) 
    {
        i = 0;
        LCD_ref = 0x01;
    }            
 
}

void main(void)
{
// Declare your local variables here
  


    // Initialize ports and pins
    // Configure SEVENSEG_PORT, KEYPAD_PORT, BUZZER_PORT, and LED_PORT as required 
    
    // Set ROWS as outputs and COLS as inputs
     DDRB = 0xFF; // Assuming keypad is connected to PORTB pins 0-3 as COLS
//    PORTB = 0x00; // Activate internal pull-ups on PORTB pins 0-3 as COLS    
     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0); 
     PORTA=(1<<PORTA7) | (1<<PORTA6) |(1<<PORTA5) |(1<<PORTA4) |(0<<PORTA3) |(0<<PORTA2) |(0<<PORTA1) | (0<<PORTA7);      
     DDRC = 0xFF; // Assuming seven segment display is connected to PORTC  
     DDRD = 0xFF; // Assuming LEDs are connected to PORTD   

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
// Timer Period: 9.984 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x4D;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: CTC top=OCR1A
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 1 s
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: On
//TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
//TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
//TCNT1H=0x00;
//TCNT1L=0x00;
//ICR1H=0x00;
//ICR1L=0x00;
//OCR1AH=0x7A;
//OCR1AL=0x11;
//OCR1BH=0x00;
//OCR1BL=0x00;
//
//
//// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (1<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);


 // Read minutes input from keypad      
// Global enable interrupts
#asm("sei")
while (1)
      {  
      // Place your code here 
       key = read_keypad();  
       getval(key);
//       blink_segment(1); 
    display_on_seven_segment_minute(minutes);

    }
}


void blink_segment(char mode)
{
 switch (mode)
 { 
 //PORTC = 0xFE;
  case 1:
  PORTC = ~(segments[digit[i]]); 
  case 2:
  PIND.1=0;
  
 }
}

void display_on_seven_segment_minute(char minute) {     

    // Extract digits from the number
     digit[0] = minute / 10;
     digit[1] = minute % 10;            
}
void display_on_seven_segment_second(char second) {     

    // Extract digits from the number
     digit[2] = second / 10;
     digit[3] = second % 10;            
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
       while(1)
       {  
        if( key == '=')
           { 
                seconds = digit2;
                //display_on_seven_segment_second(digit2);
                digit1 =0;
                break;
           } 
        if ( key == '+')        //if + was entered 
           {
            minutes= digit2;   
           // display_on_seven_segment_minute(digit2); //show on 7Seg 
            digit1=0;   
                       
            break; 
            } 
           if(digit1)
           {
              digit2= digit1*10 + key - '0';
              return digit2;
           }       
          if ( (key >= '0') && (key<= '9') )
           { 
            digit1 = key - '0';
           // digit1= digit2 + key - '0';
            return digit1;   
           }    



       } 
            

      }   
    }


