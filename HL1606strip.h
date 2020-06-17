/*!
 * @file HL1606strip.h
 *
 * LEDStrip - Arduino driver for HL1606-based LED strips
 * Thanks to: John M Cohn
 * Copyright (c) 2009, Synoptic Labs
 * All rights reserved.
 *
 *   Some higher level commands added by ladyada
 *
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the \<organization\> nor the
 *     names of its contributors may be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY SYNOPTIC LABS ''AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL SYNOPTIC LABS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef HL1606strip_h
#define HL1606strip_h

#include <inttypes.h>

/*!
 * Commands to send to the LED strip
 */
enum {
  OFF,   //!< 0b00, Turns LED off
  ON,    //!< 0b01, Turns LED on
  UP,    //!< 0b10, Fades up to max brightness
  DOWN,  //!< 0b11, Fades down to min birightness
  NONCMD //!< Value when no command is being sent
};

#define LATCH (_BV(7))   //!< Says whether or not the LED can be read
#define SPEED2X (_BV(6)) //!< Sets speed to double

// colors, each bit one LED
#define BLACK 0b000  //!< Binary representation of black color
#define WHITE 0b111  //!< Binary representation of black color
#define RED 0b100    //!< Binary representation of black color
#define YELLOW 0b110 //!< Binary representation of black color
#define GREEN 0b010  //!< Binary representation of black color
#define TEAL 0b011   //!< Binary representation of black color
#define BLUE 0b001   //!< Binary representation of black color
#define VIOLET 0b101 //!< Binary representation of black color

/*!
 * @brief HL1606 LED strip driver
 */
class HL1606strip {
private:
  uint8_t _dPin;
  uint8_t _sPin;
  uint8_t _latchPin;
  uint8_t _clkPin;
  uint8_t _faderEnabled;
  unsigned int _faderPulseHalfWidth;
  unsigned int _faderPulseNewHalfWidth;
  unsigned long _faderPulseNextEdge;

  // we will control up to 255 LEDs!
  uint8_t *_leds;
  uint8_t _numLEDs;

public:
  /*!
   * @brief HL1606strip object
   * @param dPin Data pin
   * @param sPin Strobe pin
   * @param latchPin Latch pin
   * @param clkPin Clock pin
   * @param numLEDs Number of LEDs in strip
   */
  HL1606strip(int, int, int, int, uint8_t);
  /*!
   * @brief HL1606strip object
   * @param dPin Data pin
   * @param latchPin Latch pin
   * @param clkPin Clock pin
   * @param numLEDs Number of LEDs in strip
   */
  HL1606strip(int, int, int, uint8_t);

  // some higher level commands we added
  /*!
   * @brief Sets the color of the specified LED
   * @param n LED to set
   * @param color Color to set
   */
  void setLEDcolor(uint8_t n, uint8_t color);
  /*!
   * @brief gets the color of the specified LED
   * @param n LED to get the color from
   * @return Returns the color of the LED
   */
  uint8_t getLEDcolor(uint8_t n);
  /*!
   * @brief Writes to the whole LED strip
   */
  void writeStrip(void);
  /*!
   * @brief Returns the number of connected LEDs
   * @return Returns the number of connected LEDs
   */
  uint8_t numLEDs(void);
  /*!
   * @brief Push a color down the strip, setting the latch-enable flag.
   * @param redcmd Command to send to the green LEDs
   * @param greencmd Command to send to the red LEDs
   * @param bluecmd Command to send to the blue LEDs
   * @return Returns the pushed command
   */
  uint8_t rgbPush(uint8_t, uint8_t, uint8_t);
  /*!
   * @brief Push a color down the strip at 2x speed, setting the latch-enable
   * flag.
   * @param redcmd Command to send to the green LEDs
   * @param greencmd Command to send to the red LEDs
   * @param bluecmd Command to send to the blue LEDs
   * @return Returns the pushed command
   */
  uint8_t rgbPush2X(uint8_t, uint8_t, uint8_t);
  /*!
   * @brief Pushes specified command to LED strip
   * @param cmd Command to push
   */
  void pushCmd(uint8_t);
  /*!
   * @brief Push a blank value down the strip, not setting latch-enable flag.
   * Does not affect the status of a particular LED when latched. It's
   * like using whitespace
   */
  void blankPush();
  /*!
   * @brief Enables the latch pin
   */
  void latch();
  /*!
   * @brief Puts the LED strip into sleep mode
   */
  void sleep();
  /*!
   * @brief Wakes up the LED strip after it has been in sleep mode
   */
  void wakeup();
  /*!
   * @brief Sets the fader speed
   * @param halfWidthms Desired half-width fader pulse time (ms). Can be set to
   * 0 to disable fader
   */
  void faderSpeedSet(unsigned int);
  /*!
   * @brief Gets the fader's speed in ms
   * @return Returns the fader speed in ms
   */
  unsigned int faderSpeedGet();
  /*!
   * @brief Increases fader speed
   */
  void faderCrank();
  /*!
   * @brief does strobe pin pulse
   */
  void sPulse();
};

#endif
