#include <mega32.h>
#include <delay.h>
// Declare your global variables here
int LCD_ref=0x0D, i=0, digit[2];
    int row = 0, col =-1, input = -1, pos = 0;
#define col0    PINA.4
#define col1    PINA.5
#define col2    PINA.6
#define col3    PINA.7  

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
    
    char row_ref[]= {
            0b00000001,
            0b00000010,
            0b00000100,
            0b00001000
            };  

// Function prototypes
void display_on_seven_segment(int number);
int read_keypad();

void main(void)
{
// Declare your local variables here
int key;  int minutes = 0,seconds = 0;

    // Initialize ports and pins
    // Configure SEVENSEG_PORT, KEYPAD_PORT, BUZZER_PORT, and LED_PORT as required 
    
    // Set ROWS as outputs and COLS as inputs
    //DDRA = 0x0F; // Assuming keypad is connected to PORTA pins 0-3 as ROWS
    DDRB = 0xFF; // Assuming keypad is connected to PORTB pins 0-3 as COLS
    PORTB = 0x00; // Activate internal pull-ups on PORTB pins 0-3 as COLS    
    PORTA = 0x00; // Activate internal pull-ups on PORTA pins 0-3 as ROWS 
    DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);;       
    DDRC = 0xFF; // Assuming seven segment display is connected to PORTC  
    DDRD = 0xFF; // Assuming LEDs are connected to PORTD   

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
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x7A;
OCR1AL=0x11;
OCR1BH=0x00;
OCR1BL=0x00;


// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (1<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);


 // Read minutes input from keypad      
// Global enable interrupts
#asm("sei")
while (1)
      {
      // Place your code here  
      char key = read_keypad();  
      //if(key != 0)   
      //display_on_seven_segment(key);
      

      }
}




void display_on_seven_segment(int number) {
    
    // Display the given number on the seven segment display   
    int i;  
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
    
  

    // Extract digits from the number
     digit[1] = number / 10;
     digit[2] = number % 10; 
     LCD_ref = 0x01;
    for (i=0; i<4; i++)
    {
         PORTD = LCD_ref;
         PORTC = ~(segments[digit[i]]); 
         delay_ms(1);
         LCD_ref = LCD_ref<<1;
    }  
                
}


        char keypad_layout[4][4] = {
            {'x', '6', '5', '4'},
            {'-', '3', '2', '1'},
            {'+', '=', '0', 'c'}
        };
        

    int read_keypad() {
        // Read input from keypad and return the pressed key   
        char readCols;
        row++;
        if(row>3)row=0;
        PORTA =  0x01<<row;
        //delay_ms(500); 
        return;
        readCols = (PINA & 0xF0)>>4;
        if(readCols)
        {
            if(readCols & 0x01)
            {  
            return (row*4 + 0);
            }
            else if(readCols & 0x02)
            {   
            return (row*4 + 1);
            }
            else if(readCols & 0x04)
            {    
            return (row*4 + 2);
            }
            else if(readCols & 0x08)
            {   
            return (row*4 + 3);
            } 
        return 0;
        }        
        
        
        
        
        
        
        
//
//        // Loop through each ROW and check for key press    
//
//        int row = -1, col =-1;
//
//            for (row = 0; row < 4; row++) {
//                // Activate current ROW
//                PORTA = row_ref[row];  
//                delay_ms(6);
//                if (col0 == 1)
//                {
//                    while(col1 == 1);
//                    col=0;
//                    break;
//                } 
//                if (col1 == 1)
//                {
//                    while(col1 == 1);
//                    col=1;
//                    break;
//                }
//                if (col2 == 1)
//                {
//                    while(col1 == 1);
//                    col=2;
//                    break;
//                }
//                if (col3 == 1)
//                {
//                    while(col1 == 1);
//                    col=3;
//                    break;
//                }
//            } 
//            if(col != -1)
//            {
//             return  (row*4 + col);
//            }
        }



