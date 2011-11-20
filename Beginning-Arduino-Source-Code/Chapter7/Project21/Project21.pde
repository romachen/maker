#include <avr/pgmspace.h>
#include <TimerOne.h>

int DataPin = 2; // Pin 1 on MAX
int LoadPin = 3; // Pin 12 on MAX
int ClockPin = 4; // Pin 13 on MAX
byte buffer[8];

static byte font[][8] PROGMEM = {
// The printable ASCII characters only (32-126)
{B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000}, 
{B00000100, B00000100, B00000100, B00000100, B00000100, B00000100, B00000000, B00000100}, 
{B00001010, B00001010, B00001010, B00000000, B00000000, B00000000, B00000000, B00000000}, 
{B00000000, B00001010, B00011111, B00001010, B00011111, B00001010, B00011111, B00001010}, 
{B00000111, B00001100, B00010100, B00001100, B00000110, B00000101, B00000110, B00011100}, 
{B00011001, B00011010, B00000010, B00000100, B00000100, B00001000, B00001011, B00010011}, 
{B00000110, B00001010, B00010010, B00010100, B00001001, B00010110, B00010110, B00001001}, 
{B00000100, B00000100, B00000100, B00000000, B00000000, B00000000, B00000000, B00000000}, 
{B00000010, B00000100, B00001000, B00001000, B00001000, B00001000, B00000100, B00000010}, 
{B00001000, B00000100, B00000010, B00000010, B00000010, B00000010, B00000100, B00001000}, 
{B00010101, B00001110, B00011111, B00001110, B00010101, B00000000, B00000000, B00000000}, 
{B00000000, B00000000, B00000100, B00000100, B00011111, B00000100, B00000100, B00000000}, 
{B00000000, B00000000, B00000000, B00000000, B00000000, B00000110, B00000100, B00001000}, 
{B00000000, B00000000, B00000000, B00000000, B00001110, B00000000, B00000000, B00000000}, 
{B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000100}, 
{B00000001, B00000010, B00000010, B00000100, B00000100, B00001000, B00001000, B00010000}, 
{B00001110, B00010001, B00010011, B00010001, B00010101, B00010001, B00011001, B00001110}, 
{B00000100, B00001100, B00010100, B00000100, B00000100, B00000100, B00000100, B00011111}, 
{B00001110, B00010001, B00010001, B00000010, B00000100, B00001000, B00010000, B00011111}, 
{B00001110, B00010001, B00000001, B00001110, B00000001, B00000001, B00010001, B00001110}, 
{B00010000, B00010000, B00010100, B00010100, B00011111, B00000100, B00000100, B00000100}, 
{B00011111, B00010000, B00010000, B00011110, B00000001, B00000001, B00000001, B00011110}, 
{B00000111, B00001000, B00010000, B00011110, B00010001, B00010001, B00010001, B00001110}, 
{B00011111, B00000001, B00000001, B00000001, B00000010, B00000100, B00001000, B00010000}, 
{B00001110, B00010001, B00010001, B00001110, B00010001, B00010001, B00010001, B00001110}, 
{B00001110, B00010001, B00010001, B00001111, B00000001, B00000001, B00000001, B00000001}, 
{B00000000, B00000100, B00000100, B00000000, B00000000, B00000100, B00000100, B00000000}, 
{B00000000, B00000100, B00000100, B00000000, B00000000, B00000100, B00000100, B00001000}, 
{B00000001, B00000010, B00000100, B00001000, B00001000, B00000100, B00000010, B00000001}, 
{B00000000, B00000000, B00000000, B00011110, B00000000, B00011110, B00000000, B00000000}, 
{B00010000, B00001000, B00000100, B00000010, B00000010, B00000100, B00001000, B00010000}, 
{B00001110, B00010001, B00010001, B00000010, B00000100, B00000100, B00000000, B00000100}, 
{B00001110, B00010001, B00010001, B00010101, B00010101, B00010001, B00010001, B00011110}, 
{B00001110, B00010001, B00010001, B00010001, B00011111, B00010001, B00010001, B00010001}, 
{B00011110, B00010001, B00010001, B00011110, B00010001, B00010001, B00010001, B00011110}, 
{B00000111, B00001000, B00010000, B00010000, B00010000, B00010000, B00001000, B00000111}, 
{B00011100, B00010010, B00010001, B00010001, B00010001, B00010001, B00010010, B00011100},
{B00011111, B00010000, B00010000, B00011110, B00010000, B00010000, B00010000, B00011111}, 
{B00011111, B00010000, B00010000, B00011110, B00010000, B00010000, B00010000, B00010000}, 
{B00001110, B00010001, B00010000, B00010000, B00010111, B00010001, B00010001, B00001110}, 
{B00010001, B00010001, B00010001, B00011111, B00010001, B00010001, B00010001, B00010001}, 
{B00011111, B00000100, B00000100, B00000100, B00000100, B00000100, B00000100, B00011111}, 
{B00011111, B00000100, B00000100, B00000100, B00000100, B00000100, B00010100, B00001000}, 
{B00010001, B00010010, B00010100, B00011000, B00010100, B00010010, B00010001, B00010001}, 
{B00010000, B00010000, B00010000, B00010000, B00010000, B00010000, B00010000, B00011111}, 
{B00010001, B00011011, B00011111, B00010101, B00010001, B00010001, B00010001, B00010001}, 
{B00010001, B00011001, B00011001, B00010101, B00010101, B00010011, B00010011, B00010001}, 
{B00001110, B00010001, B00010001, B00010001, B00010001, B00010001, B00010001, B00001110}, 
{B00011110, B00010001, B00010001, B00011110, B00010000, B00010000, B00010000, B00010000}, 
{B00001110, B00010001, B00010001, B00010001, B00010001, B00010101, B00010011, B00001111}, 
{B00011110, B00010001, B00010001, B00011110, B00010100, B00010010, B00010001, B00010001}, 
{B00001110, B00010001, B00010000, B00001000, B00000110, B00000001, B00010001, B00001110}, 
{B00011111, B00000100, B00000100, B00000100, B00000100, B00000100, B00000100, B00000100}, 
{B00010001, B00010001, B00010001, B00010001, B00010001, B00010001, B00010001, B00001110}, 
{B00010001, B00010001, B00010001, B00010001, B00010001, B00010001, B00001010, B00000100}, 
{B00010001, B00010001, B00010001, B00010001, B00010001, B00010101, B00010101, B00001010}, 
{B00010001, B00010001, B00001010, B00000100, B00000100, B00001010, B00010001, B00010001}, 
{B00010001, B00010001, B00001010, B00000100, B00000100, B00000100, B00000100, B00000100}, 
{B00011111, B00000001, B00000010, B00000100, B00001000, B00010000, B00010000, B00011111}, 
{B00001110, B00001000, B00001000, B00001000, B00001000, B00001000, B00001000, B00001110}, 
{B00010000, B00001000, B00001000, B00000100, B00000100, B00000010, B00000010, B00000001}, 
{B00001110, B00000010, B00000010, B00000010, B00000010, B00000010, B00000010, B00001110}, 
{B00000100, B00001010, B00010001, B00000000, B00000000, B00000000, B00000000, B00000000}, 
{B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000, B00011111}, 
{B00001000, B00000100, B00000000, B00000000, B00000000, B00000000, B00000000, B00000000}, 
{B00000000, B00000000, B00000000, B00001110, B00010010, B00010010, B00010010, B00001111}, 
{B00000000, B00010000, B00010000, B00010000, B00011100, B00010010, B00010010, B00011100}, 
{B00000000, B00000000, B00000000, B00001110, B00010000, B00010000, B00010000, B00001110}, 
{B00000000, B00000001, B00000001, B00000001, B00000111, B00001001, B00001001, B00000111}, 
{B00000000, B00000000, B00000000, B00011100, B00010010, B00011110, B00010000, B00001110}, 
{B00000000, B00000011, B00000100, B00000100, B00000110, B00000100, B00000100, B00000100}, 
{B00000000, B00001110, B00001010, B00001010, B00001110, B00000010, B00000010, B00001100}, 
{B00000000, B00010000, B00010000, B00010000, B00011100, B00010010, B00010010, B00010010}, 
{B00000000, B00000000, B00000100, B00000000, B00000100, B00000100, B00000100, B00000100}, 
{B00000000, B00000010, B00000000, B00000010, B00000010, B00000010, B00000010, B00001100}, 
{B00000000, B00010000, B00010000, B00010100, B00011000, B00011000, B00010100, B00010000}, 
{B00000000, B00010000, B00010000, B00010000, B00010000, B00010000, B00010000, B00001100}, 
{B00000000, B00000000, B00000000, B00001010, B00010101, B00010001, B00010001, B00010001}, 
{B00000000, B00000000, B00000000, B00010100, B00011010, B00010010, B00010010, B00010010}, 
{B00000000, B00000000, B00000000, B00001100, B00010010, B00010010, B00010010, B00001100}, 
{B00000000, B00011100, B00010010, B00010010, B00011100, B00010000, B00010000, B00010000}, 
{B00000000, B00001110, B00010010, B00010010, B00001110, B00000010, B00000010, B00000001}, 
{B00000000, B00000000, B00000000, B00001010, B00001100, B00001000, B00001000, B00001000}, 
{B00000000, B00000000, B00001110, B00010000, B00001000, B00000100, B00000010, B00011110}, 
{B00000000, B00010000, B00010000, B00011100, B00010000, B00010000, B00010000, B00001100}, 
{B00000000, B00000000, B00000000, B00010010, B00010010, B00010010, B00010010, B00001100}, 
{B00000000, B00000000, B00000000, B00010001, B00010001, B00010001, B00001010, B00000100}, 
{B00000000, B00000000, B00000000, B00010001, B00010001, B00010001, B00010101, B00001010}, 
{B00000000, B00000000, B00000000, B00010001, B00001010, B00000100, B00001010, B00010001}, 
{B00000000, B00000000, B00010001, B00001010, B00000100, B00001000, B00001000, B00010000}, 
{B00000000, B00000000, B00000000, B00011111, B00000010, B00000100, B00001000, B00011111}, 
{B00000010, B00000100, B00000100, B00000100, B00001000, B00000100, B00000100, B00000010}, 
{B00000100, B00000100, B00000100, B00000100, B00000100, B00000100, B00000100, B00000100}, 
{B00001000, B00000100, B00000100, B00000100, B00000010, B00000100, B00000100, B00001000}, 
{B00000000, B00000000, B00000000, B00001010, B00011110, B00010100, B00000000, B00000000}  
};

void clearDisplay() {
        for (byte x=0; x<8; x++) {
                buffer[x] = B00000000;
        }
        screenUpdate();
}

void initMAX7219() {
        pinMode(DataPin, OUTPUT);
        pinMode(LoadPin, OUTPUT);
        pinMode(ClockPin, OUTPUT);
        clearDisplay();
        writeData(B00001011, B00000111); // scan limit set to 0:7
        writeData(B00001001, B00000000); // decode mode off
        writeData(B00001100, B00000001); // Set shutdown register to normal operation
        intensity(15); // Values 0 to 15 only (4 bit)
}
  
void intensity(int intensity) {
        writeData(B00001010, intensity); //B0001010 is the Intensity Register
        }

void writeData(byte MSB, byte LSB) {
        byte mask;
        digitalWrite(LoadPin, LOW); // set loadpin ready to receive data
        // Send out MSB  
        for (mask = B10000000; mask>0; mask >>= 1) { //iterate through bit mask
                digitalWrite(ClockPin, LOW);
                if (MSB & mask){ // if bitwise AND resolves to true
                        digitalWrite(DataPin,HIGH); // send 1
                }
                else{ //if bitwise and resolves to false
                        digitalWrite(DataPin,LOW); // send 0
                }
                digitalWrite(ClockPin, HIGH); // clock high, data gets input
        }
        // send out LSB for data
         for (mask = B10000000; mask>0; mask >>= 1) { //iterate through bit mask
                digitalWrite(ClockPin, LOW);
                if (LSB & mask){ // if bitwise AND resolves to true
                        digitalWrite(DataPin,HIGH); // send 1
                }
                else{ //if bitwise and resolves to false
                        digitalWrite(DataPin,LOW); // send 0
                }
                digitalWrite(ClockPin, HIGH); // clock high, data gets input
        }
        digitalWrite(LoadPin, HIGH); // latch the data
        digitalWrite(ClockPin, LOW);
}


void scroll(char myString[], int speed) {
        byte firstChrRow, secondChrRow;
        byte ledOutput;
        byte chrPointer = 0; // Initialise the string position pointer
        byte Char1, Char2; // the two characters that will be displayed
        byte scrollBit = 0;
        byte strLength = 0;
        unsigned long time;
        unsigned long counter;

        // Increment count till we reach the string 
        while (myString[strLength]) {strLength++;}

        counter = millis();
         while (chrPointer < (strLength-1)) {
                time = millis();
                if (time > (counter + speed)) {
                        Char1 = myString[chrPointer];
                        Char2 = myString[chrPointer+1];
                        for (byte y= 0; y<8; y++) {
                                firstChrRow = pgm_read_byte(&font[Char1 - 32][y]);
                                secondChrRow = (pgm_read_byte(&font[Char2 - 32][y])) << 1;
                                ledOutput = (firstChrRow << scrollBit) | (secondChrRow >>
 (8 - scrollBit) );
                                buffer[y] = ledOutput;
                        }
                        scrollBit++; 
                        if (scrollBit > 6) { 
                        scrollBit = 0;
                        chrPointer++;
                        }
                        counter = millis();
                }
        }
}

void screenUpdate() {
        for (byte row = 0; row < 8; row++) {
                writeData(row+1, buffer[row]);
        }
}

void setup() {
        initMAX7219();
        Timer1.initialize(10000);         // initialize timer1 and set interrupt period
        Timer1.attachInterrupt(screenUpdate); 
}

void loop() {
        clearDisplay();    
        scroll("   BEGINNING ARDUINO   ", 45);
        scroll("   Chapter 7 - LED Displays   ", 45);
        scroll("   HELLO WORLD!!!  :)   ", 45);
}

