/*
This is the most basic demonstration code of using HL1606-based digital LED strips. 
The HL1606 chips are not very 'smart' and do not have built in PWM control. (Although
there is a fading ability, its not that useful)

We have a few examples of using the setLEDcolor() and writeStrip() command that will 
allow changing the strip around
*/


// HL1606strip is an adaptation of LEDstrip from  http://code.google.com/p/ledstrip/
#include "HL1606strip.h"

#define STRIP_S 12
#define STRIP_D 11
#define STRIP_C 13
#define STRIP_L 10

// Pin S is not really used in this demo since it doesnt use the built in PWM fade
// The last argument is the number of LEDs in the strip. Each chip has 2 LEDs, and the number
// of chips/LEDs per meter varies so make sure to count them! if you have the wrong number
// the strip will act a little strangely, with the end pixels not showing up the way you like
HL1606strip strip = HL1606strip(STRIP_D, STRIP_S, STRIP_L, STRIP_C, 32);


void setup(void) {
  // nothing to do!
}

void loop(void) { 
   // first argument is the color, second is the delay in milliseconds between commands
   
   // test all the LED colors with a wipe
   colorWipe(RED, 20);
   colorWipe(YELLOW, 20);
   colorWipe(GREEN, 20);
   colorWipe(TEAL, 20);
   colorWipe(BLUE, 20);
   colorWipe(VIOLET, 20);
   colorWipe(WHITE, 20);
   colorWipe(BLACK, 20);

   // then a chase
   chaseSingle(RED, 20);
   chaseSingle(YELLOW, 20);
   chaseSingle(GREEN, 20);
   chaseSingle(TEAL, 20);
   chaseSingle(VIOLET, 20);
   chaseSingle(WHITE, 20);
   
   // a colorcycle party!
   rainbowParty(40);
}



/**********************************************/

// scroll a rainbow!
void rainbowParty(uint8_t wait) {
  uint8_t i, j;

  for (i=0; i< strip.numLEDs(); i+=6) {
    // initialize strip with 'rainbow' of colors
    strip.setLEDcolor(i, RED);
    strip.setLEDcolor(i+1, YELLOW);
    strip.setLEDcolor(i+2, GREEN);
    strip.setLEDcolor(i+3, TEAL);
    strip.setLEDcolor(i+4, BLUE);
    strip.setLEDcolor(i+5, VIOLET);
 
  }
  strip.writeStrip();   
  
  for (j=0; j < strip.numLEDs(); j++) {

    // now set every LED to the *next* LED color (cycling)
    uint8_t savedcolor = strip.getLEDcolor(0);
    for (i=1; i < strip.numLEDs(); i++) {
      strip.setLEDcolor(i-1, strip.getLEDcolor(i));  // move the color back one.
    }
    // cycle the first LED back to the last one
    strip.setLEDcolor(strip.numLEDs()-1, savedcolor);
    strip.writeStrip();
    delay(wait);
  }
}


// turn everything off (fill with BLACK)
void stripOff(void) {
  // turn all LEDs off!
  for (uint8_t i=0; i < strip.numLEDs(); i++) {
      strip.setLEDcolor(i, BLACK);
  }
  strip.writeStrip();   
}

// have one LED 'chase' around the strip
void chaseSingle(uint8_t color, uint8_t wait) {
  uint8_t i;
  
  // turn everything off
  for (i=0; i< strip.numLEDs(); i++) {
    strip.setLEDcolor(i, BLACK);
  }

  for (i=0; i < strip.numLEDs(); i++) {
    strip.setLEDcolor(i, color);
    if (i != 0) {
      // make the LED right before this one OFF
      strip.setLEDcolor(i-1, BLACK);
    }
    strip.writeStrip();
    delay(wait);  
  }
  // turn off the last LED before leaving
  strip.setLEDcolor(strip.numLEDs() - 1, BLACK);
}

// fill the entire strip, with a delay between each pixel for a 'wipe' effect
void colorWipe(uint8_t color, uint8_t wait) {
  uint8_t i;
  
  for (i=0; i < strip.numLEDs(); i++) {
      strip.setLEDcolor(i, color);
      strip.writeStrip();   
      delay(wait);
  }
}


