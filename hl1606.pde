#include "LEDStrip.h"

// dot is S
// dash is Data
// x is Clock
// longdash is latch

#define STRIP_S 2
#define STRIP_D 3
#define STRIP_C 4
#define STRIP_L 5
byte colorArray[15];

#define BLACK 0b000
#define WHITE 0b111
#define RED 0b100
#define YELLOW 0b110
#define GREEN 0b010
#define TEAL 0b011
#define BLUE 0b001
#define VIOLET 0b101
 
#define numLEDs (32*5)  // 32 leds per meter

LEDStrip strip = LEDStrip(STRIP_D, STRIP_S, STRIP_L, STRIP_C);

uint8_t leds[numLEDs];


void setup(void) {
  Serial.begin(9600);
  
  Serial.print("hello!");

   fillStrip(BLACK);
  delay(1000);

}


void loop(void) { 
   fillStrip(RED);
   fillStrip(YELLOW);
   fillStrip(GREEN);
   fillStrip(TEAL);
   fillStrip(BLUE);
   fillStrip(VIOLET);
   fillStrip(WHITE);
   fillStrip(BLACK);

   chaseSingle(RED);
   chaseSingle(YELLOW);
   chaseSingle(GREEN);
   chaseSingle(TEAL);
   chaseSingle(VIOLET);
   chaseSingle(WHITE);
    rainbow();
  
}

/**********************************************/

void setLED(uint8_t n, uint8_t color) {
  uint8_t x;
  
  x = 0x80; // latch
  
  if (n > numLEDs) return;

  if (color & BLUE) 
    x |= 0x01;
  if (color & RED) 
    x |= 0x04;
  if (color & GREEN) 
    x |= 0x10;
  
  leds[n] = x;
}

void fadeLEDin(uint8_t n, uint8_t color) {
  uint8_t x;
  
  x = 0x80; // latch
  
  if (n > numLEDs) return;

  if (color & BLUE) 
    x |= 0x02;
  if (color & RED) 
    x |= 0x08;
  if (color & GREEN) 
    x |= 0x20;
  
  leds[n] = x;
}


void fadeLEDout(uint8_t n, uint8_t color) {
  uint8_t x;
  
  x = 0x80; // latch
  
  if (n > numLEDs) return;

  if (color & BLUE) 
    x |= 0x03;
  if (color & RED) 
    x |= 0x0C;
  if (color & GREEN) 
    x |= 0x30;
  
  leds[n] = x;
}

uint8_t getLED(uint8_t n) {
  uint8_t x;

  if (n > numLEDs) return 0;
  
  x = leds[n];
  
  x &= 0x7F; // get rid of latch
  
  uint8_t r, g, b;
  r = g = b = 0;
  if (x & 0x3) { b = 1; }
  if (x & 0xC) { r = 1; } 
  if (x & 0x30) { g = 1; }
  
  return (g << 1) | (r << 2) | b;
}


// this takes about 20ms for a 160 LED strip
void writestrip(void) {
  for (uint8_t i=0; i<numLEDs; i++) {
    strip.pushCmd(leds[numLEDs-1-i]);
  }
  strip.latch();
  
}

/**********************************************/

void rainbow(void) {
  uint8_t i;

  for (i=0; i<numLEDs; i+=6) {
    setLED(i, RED);
    setLED(i+1, YELLOW);
    setLED(i+2, GREEN);
    setLED(i+3, TEAL);
    setLED(i+4, BLUE);
    setLED(i+5, VIOLET);
 
  }
  writestrip();   
  
  for (uint8_t j=0; j<numLEDs; j++) {
    uint8_t savedcolor = getLED(0);
    for (i=1; i<numLEDs; i++) {
      setLED(i-1, getLED(i));
    }
    setLED(numLEDs-1, savedcolor);
    writestrip();
    delay(50);
  }
}


void rainbowfade(void) {
  uint8_t i;

  for (i=0; i<numLEDs; i+=6) {
    setLED(i, RED);
    setLED(i+1, YELLOW);
    setLED(i+2, GREEN);
    setLED(i+3, TEAL);
    setLED(i+4, BLUE);
    setLED(i+5, VIOLET);
 
  }
  writestrip();   
  
  for (uint8_t j=0; j<numLEDs; j++) {
    for (i=0; i<numLEDs; i++) {
      fadeLEDout(i, getLED(i));
    }
    
    for (i=0; i< 64; i++) {
          strip.sPulse();
          delay(10);
    }
    
    uint8_t savedcolor = getLED(0);
    for (i=1; i<numLEDs; i++) {
      fadeLEDin(i-1, getLED(i));
    }
    //fadeLEDin(numLEDs-1, savedcolor);
    //writestrip();
    //for (i=0; i< 64; i++) {
    //      strip.sPulse();
    //      delay(10);
    //}
  }
}

void stripOff(void) {
  // turn all LEDs off!
  for (uint8_t i=0; i<numLEDs; i++) {
      setLED(i, BLACK);
  }
  writestrip();   
}

void chaseSingle(uint8_t color) {
  uint8_t i;
  
  // turn everything off
  for (i=0; i< numLEDs; i++) {
    setLED(i, BLACK);
  }

  for (i=0; i< numLEDs; i++) {
    setLED(i, color);
    if (i != 0) {
      setLED(i-1, BLACK);
    }
    writestrip();
    delay(10);  
  }
  setLED(numLEDs-1, BLACK);
}


void fillStrip(uint8_t color) {
  uint8_t i;
  
  for (i=0; i<numLEDs; i++) {
      setLED(i, color);
      writestrip();   
  }
}
