#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

// Define pins for seven segment display, keypad, buzzer, and LEDs
#define SEVENSEG_PORT PORTA
#define KEYPAD_PORT PORTB
#define BUZZER_PORT PORTC
#define LED_PORT PORTD

// Function prototypes
void init();
char read_keypad();
void display_on_seven_segment(int number);
void countdown_timer(int minutes, int seconds);
void sound_buzzer();
void led_animation();

int main() {
    init();
    int minutes = 0, seconds = 0;
    char key;
    
    // Read minutes input from keypad
    while(1) {
        key = read_keypad();
        if(key >= '0' && key <= '9') {
            minutes = minutes * 10 + (key - '0');
            display_on_seven_segment(minutes);
        }
        else if(key == '+') {
            // Read seconds input from keypad
            while(1) {
                key = read_keypad();
                if(key >= '0' && key <= '9') {
                    seconds = seconds * 10 + (key - '0');
                    display_on_seven_segment(seconds);
                }
                else if(key == '=') {
                    display_on_seven_segment(minutes);
                    _delay_ms(1000);
                    display_on_seven_segment(seconds);
                    _delay_ms(1000);
                    break;
                }
            }
            break;
        }
    }
    
    // Wait for ON/C key to start countdown
    while(1) {
        if(read_keypad() == 'ON/C') {
            countdown_timer(minutes, seconds);
            break;
        }
    }
    
    // Once countdown finishes, sound buzzer and start LED animation
    sound_buzzer();
    led_animation();
    
    return 0;
}

void init() {
    // Initialize ports and pins
    // Configure SEVENSEG_PORT, KEYPAD_PORT, BUZZER_PORT, and LED_PORT as required
}

char read_keypad() {
    // Read input from keypad and return the pressed key
    // Define keypad layout (assuming a 4x4 matrix)
    char keypad_layout[4][4] = {
        {'1', '2', '3', '+'},
        {'4', '5', '6', '-'},
        {'7', '8', '9', '*'},
        {'ON/C', '0', '=', '/'}
    };

    // Set ROWS as outputs and COLS as inputs
    DDRC = 0x0F; // Assuming keypad is connected to PORTC pins 0-3 as ROWS
    PORTC = 0xF0; // Activate internal pull-ups on PORTC pins 4-7 as COLS

    // Loop through each ROW and check for key press
    for (int row = 0; row < 4; row++) {
        // Activate current ROW
        PORTC = (PORTC & 0xF0) | ~(1 << row);

        // Check for key press in current ROW
        for (int col = 4; col < 8; col++) {
            if (!(PINC & (1 << col))) {
                // Key pressed, return corresponding character from keypad layout
                return keypad_layout[row][col - 4];
            }
        }
    }

    // No key pressed, return null character
    return '\0';
}

void display_on_seven_segment(int number) {
    // Display the given number on the seven segment display 
    void display_on_seven_segment(int number) {
    // Define the segments for each digit (assuming common cathode display)
    const int segments[] = {
        // 0bGFEDCBA
        0x3F, // 0
        0x06, // 1
        0x5B, // 2
        0x4F, // 3
        0x66, // 4
        0x6D, // 5
        0x7D, // 6
        0x07, // 7
        0x7F, // 8
        0x6F // 9
    };

    // Extract digits from the number
    int digit1 = number / 10;
    int digit2 = number % 10;

    // Define the pins connected to the seven segment display
    DDRA = 0xFF; // Assuming seven segment display is connected to PORTA

    // Display the first digit
    PORTA = segments[digit1];
    // Assume pins A0-A3 are connected to the common cathode/anode of the first digit
    // Activate the first digit by setting pins A0-A3 LOW and others HIGH
    PORTA |= 0x0F;

    _delay_ms(1); // Adjust delay as needed for display stability

    // Display the second digit
    PORTA = segments[digit2];
    // Assume pins A4-A7 are connected to the common cathode/anode of the second digit
    // Activate the second digit by setting pins A4-A7 LOW and others HIGH
    PORTA |= 0xF0;

    _delay_ms(1); // Adjust delay as needed for display stability
}
     
}

volatile int remaining_seconds;

void countdown_timer(int minutes, int seconds) {
    // Countdown from the given minutes and seconds
    // Calculate total seconds
    remaining_seconds = minutes * 60 + seconds;

    // Set up Timer1 for countdown
    TCCR1B |= (1 << CS12) | (1 << CS10); // Set prescaler to 1024
    TCNT1 = 0; // Initialize counter value
    OCR1A = 15625; // Timer overflow occurs every second
    TIMSK |= (1 << OCIE1A); // Enable Timer1 Compare A interrupt

    sei(); // Enable global interrupts

    while(remaining_seconds > 0) {
        // Wait for countdown to finish
    }
}

// Timer1 Compare A interrupt service routine
ISR(TIMER1_COMPA_vect) {
    remaining_seconds--;
}

void sound_buzzer() {
    // Activate the buzzer to sound 
    // Define the pin connected to the buzzer
    DDRC |= (1 << PC0); // Assuming buzzer is connected to pin PC0

    // Activate the buzzer by setting the corresponding pin HIGH
    PORTC |= (1 << PC0);

    // Delay for the buzzer sound duration
    _delay_ms(1000); // Adjust the delay as needed for desired sound duration

    // Deactivate the buzzer by setting the corresponding pin LOW
    PORTC &= ~(1 << PC0);
}

void led_animation() {
    // Start the LED animation 
    // Define pins connected to the LEDs
    DDRD = 0xFF; // Assuming LEDs are connected to PORTD

    // LED dance pattern
    int pattern[] = {
        0xAA, // Alternating on/off pattern
        0x55 // Inverted alternating on/off pattern
    };

    // Loop through the pattern to animate LEDs
    for (int i = 0; i < sizeof(pattern) / sizeof(pattern[0]); i++) {
        // Display current pattern on LEDs
        PORTD = pattern[i];

        // Delay for animation effect
        _delay_ms(100); // Adjust delay as needed for desired animation speed
    }

    // Turn off all LEDs after animation
    PORTD = 0x00;
}

