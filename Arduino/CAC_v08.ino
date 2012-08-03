/*
  Copyright (c) 2012 David Menting <david@nut-bolt.nl>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

  ===========
  
  Infrared irSensor reader for the Computer Augmented Crafts installation by Christian Fiebig
  
  Hardware:
  36 IR leds hooked up to port 1-9 of four 74HC4017 decade counters.
  The Master Reset and !Clock Enable pins of the 74HC4017 are tied to the SEL1-SEL4 pins.
  IR phototransistor hooked up to IR_SENSE
  
  Based on digital caliper readout code for the MSP430 by Robocombo: http://robocombo.blogspot.nl/2010/12/using-tis-launchpad-to-interface.html
  (used with permission)
  
*/
#define IR_SENSE 11

//PD5
#define HC4017_CLK 5
//PD6
#define HC4017_SEL1 6
//PD7
#define HC4017_SEL2 7
//PB0
#define HC4017_SEL3 8
//PB1
#define HC4017_SEL4 9

#define LED_ARRAY_SINK  4

#define CAL_CLK  2
#define CAL_PWR  A0
#define CAL_DATA 12

#define STRIP A3
#define CUT A2

// The frequency to pulse the LEDs at. Match this to your IR receiver.
#define LED_ARRAY_FREQ 36000

// The actual cutting plate is this many tenths of a mm from the caliper's zero point
#define CALIPER_OFFSET 220
// The minimum distance at which a strip can be reliably detected (the length slider will cover the strip detector otherwise)
#define MINIMUM_DISTANCE 500


// Create an array to hold the values for 36 ADC readings
char matchCounter;
char i;
char m;
char j;
char a;
volatile char strip;
volatile char cut;
uint16_t irSensor[4];
uint16_t irSensorPrevious[4];
volatile char flag;
int previousValue;
volatile int16_t caliperValue;
volatile int16_t value;          // value received from caliper
volatile uint16_t lastInterrupt;               // when was the last interrupt?
uint16_t now;
unsigned volatile char bits_so_far;   // current bit count during value "assembly"
volatile char caliperFlag;
unsigned char angleHeaderSent;

char readOuterRing() {
  char matches;
  
  PORTD |= (1<<PD6) | (1<<PD7); PORTB |= (1<<PB0) | (1<<PB1);
  //Equivalent to digitalWrite(HC4017_SEL1, HIGH);  digitalWrite(HC4017_SEL2, HIGH);  digitalWrite(HC4017_SEL3, HIGH);  digitalWrite(HC4017_SEL4, HIGH);
  
  char k;
  for(k = 0; k < 36; k++) {
    switch(k) {
      case 0:
        digitalWrite(HC4017_SEL4, HIGH);
        digitalWrite(HC4017_SEL1, LOW);
        a=0;
        irSensor[a] = 0;
        break;
       case 9:
        digitalWrite(HC4017_SEL1, HIGH);
        digitalWrite(HC4017_SEL2, LOW);
        a++;
        irSensor[a] = 0;
        break;
       case 18:
        digitalWrite(HC4017_SEL2, HIGH);
        digitalWrite(HC4017_SEL3, LOW);
        a++;
        irSensor[a] = 0;
        break;
       case 27:
        digitalWrite(HC4017_SEL3, HIGH);
        digitalWrite(HC4017_SEL4, LOW);
        a++;
        irSensor[a] = 0;
        break;
    }
    // The 74HC4017 advances one LED for every clock pulse
    digitalWrite(HC4017_CLK,HIGH);
    digitalWrite(HC4017_CLK,LOW);
    
    //for(j = 0; j < 4; j++) {
      delayMicroseconds(400);
      tone(LED_ARRAY_SINK, LED_ARRAY_FREQ);
      delayMicroseconds(400);
      noTone(LED_ARRAY_SINK);
    //}
    irSensor[a] <<= 1;
    if(digitalRead(IR_SENSE)) {
      irSensor[a] |= 1;
      matches++;
    }
  }
  
  PORTD |= (1<<PD6) | (1<<PD7); PORTB |= (1<<PB0) | (1<<PB1);
  //Equivalent to digitalWrite(HC4017_SEL1, HIGH);  digitalWrite(HC4017_SEL2, HIGH);  digitalWrite(HC4017_SEL3, HIGH);  digitalWrite(HC4017_SEL4, HIGH);
  return matches;
}

void setup(){
  // TODO: do this with direct port manipulation
  pinMode(HC4017_CLK, OUTPUT);

  pinMode(HC4017_SEL1, OUTPUT);
  pinMode(HC4017_SEL2, OUTPUT);
  pinMode(HC4017_SEL3, OUTPUT);
  pinMode(HC4017_SEL4, OUTPUT);
  
  // The cathode of the leds is connected to this pin. 
  pinMode(LED_ARRAY_SINK, OUTPUT);
  
  PORTD |= (1<<PD6) | (1<<PD7); PORTB |= (1<<PB0) | (1<<PB1);

  //Caliper pins
  pinMode(CAL_CLK, INPUT);
  pinMode(CAL_DATA, INPUT); 
  pinMode(CAL_PWR, OUTPUT);
  digitalWrite(CAL_PWR, HIGH);
  digitalWrite(CAL_CLK, HIGH);
  digitalWrite(CAL_DATA, HIGH);

  //CNY70 sensors for cut and strip
  pinMode(A3, INPUT);
  pinMode(A2, INPUT);

  Serial.begin(57600);

  // External interrupts for caliper clock and weld button
  attachInterrupt(0, caliper, RISING);
  attachInterrupt(1, weld, FALLING);

  // Enable pin change interrupts for CNY70 sensors
  PCICR = (1 << PCIE1);
  PCMSK1 = (1<<PCINT10) | (1<<PCINT11);
}

void loop() {
  /*
    Read the angle sensor
   */
  if(readOuterRing()) {
    // If all the values are the same, do nothing
    if(irSensor[0] == irSensorPrevious[0] &&
       irSensor[1] == irSensorPrevious[1] &&
       irSensor[2] == irSensorPrevious[2] &&
       irSensor[3] == irSensorPrevious[3]) {}
     else {
      // Loop through the array of IR sensor values.
      for(i = 0; i < 4; i ++) {        
        for(m = 0; m < 9; m++) { 
          if(irSensor[i] & (1<<(8-m))) {
             matchCounter++;
          } else {
           
           if(matchCounter == 0) { 
              continue;
            } else if(matchCounter == 1) { // If not a match and match counter == 1, add previous value to the output array.
              if(!angleHeaderSent) {
                Serial.print("a ");
                angleHeaderSent = 1;
              }
              Serial.print(10*(m + 9*i), DEC);            
            }  else {  // If match counter > 1, set the center value to the output array 
              int16_t centerValue = ((10*(m + 9*i)) - ((matchCounter*10)/2));
              //if(centerValue < 0) centerValue = 360 + centerValue;
              if(!angleHeaderSent) {
                Serial.print("a ");
                angleHeaderSent = 1;
              }
              Serial.print(centerValue, DEC);
            }
            if(angleHeaderSent) Serial.print(" \n");
            angleHeaderSent = 0;
            matchCounter = 0;
          }
        }
      }
      matchCounter = 0;
      
      if(irSensor[0] == 0 &&
       irSensor[1] == 0 &&
       irSensor[2] == 0 &&
       irSensor[3] == 0) { Serial.print("a 0\n");}
      // Store previous values so they don't get sent again
      irSensorPrevious[0] = irSensor[0];
      irSensorPrevious[1] = irSensor[1];
      irSensorPrevious[2] = irSensor[2];
      irSensorPrevious[3] = irSensor[3];
    }  
  }
  /*
    Check for cuts and welds
   */
  if(flag) {
    if((cut & B11)==B10) { Serial.print("c\n");}
    else if((strip & B11)==B10 && caliperValue > MINIMUM_DISTANCE) { Serial.print("s 1\n"); }
    else if((strip & B11)) { Serial.print("s 0\n");}
    flag = 0;
  }
  if(caliperFlag) {
   if(caliperValue < 0) {
      caliperValue = 0;
      digitalWrite(CAL_PWR, LOW);
      delay(20);
      digitalWrite(CAL_PWR, HIGH);
  }

   if(caliperValue != previousValue) {
     Serial.print("l ");
     Serial.print(caliperValue, DEC);
     Serial.print("\n");
     previousValue = caliperValue;
   }
   caliperFlag = 0;
 }
}

void weld() {
  Serial.print("w\n");
}

void caliper() {
  unsigned char data;
  data = digitalRead(CAL_DATA); // read DATA port value as soon as possible (otherwise it might be gone)
  
  now = millis();
  if((now - lastInterrupt) > 50) {
    // More than 50 msec have passed since the last clock pulse. Let's start with a new value
    value = 0;
    bits_so_far = 0;
  } else {
      if (bits_so_far && bits_so_far < 15){              // first bit is start bit, ignore it. Total we have 24 bits. But we need only 16
        value = value >> 1;  
        if(!data) 
          value |= (1 << 14);            // and move it one right
      } else if (bits_so_far == 20) { // 21st bit indicates sign (+/-)
         if (!data)  
              value = (~value)+1;          // make it negative
      } else if (bits_so_far == 22) {
          caliperValue = value/10 + CALIPER_OFFSET;
          caliperFlag = 1;
      }
      bits_so_far++;
   }
   lastInterrupt = now;
}

ISR(PCINT1_vect) {
  flag = 1;
  // Shift the old value left and add the new value to the right
  // We use this for a history of readings so we can detect a rising or falling edge.
  strip = (strip << 1) | ~digitalRead(STRIP);
  cut = (cut << 1) | ~digitalRead(CUT);
}
