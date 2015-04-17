#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <avr/interrupt.h>

#include "I2C_slave.h"

// buffer used to convert integer to string
char buffer[3];

#define LED PB0

#define PIN_READ PC0
#define PIN_MUXA PD5
#define PIN_MUXB PD6
#define PIN_MUXC PD7
#define PIN_CS0 PB0
#define PIN_CS1 PB1
#define PIN_CS2 PB2
#define PIN_STATUS PB5

#define SINGLE_SENSOR
#define I2C_ID 0x34
//#define DEBUG

// 35
// 33
// 34
// 32


void set_led_state(unsigned char s)
{
    if (s) PORTB|=_BV(PIN_STATUS);
    else PORTB&=~_BV(PIN_STATUS);
}

void outputb(unsigned int pin, unsigned char s)
{
    if (s) PORTB|=_BV(pin);
    else PORTB&=~_BV(pin);
}

void outputd(unsigned int pin, unsigned char s)
{
    if (s) PORTD|=_BV(pin);
    else PORTD&=~_BV(pin);
}

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))


int main(void){
  	I2C_init(I2C_ID<<1); // initalize as slave with address 0x32

	// allow interrupts
        sei();

        // setup outputs
        DDRB = 0x00;
        DDRB |= _BV( PIN_STATUS );
        DDRB |= _BV( PIN_CS0 );
        DDRB |= _BV( PIN_CS1 );
        DDRB |= _BV( PIN_CS2 );

        DDRD = 0x00;
        DDRD |= _BV( PIN_MUXA );
        DDRD |= _BV( PIN_MUXB );
        DDRD |= _BV( PIN_MUXC );

        DDRC = 0x00;

        outputd(PIN_MUXA, 0);
        outputd(PIN_MUXB, 0);
        outputd(PIN_MUXC, 0);
        outputb(PIN_CS0, 0);
        outputb(PIN_CS1, 1);
        outputb(PIN_CS2, 1);

        for (int i=0; i<0xFF; i++) {
          i2cbuffer[i]=99;
        }

        int bank = 0;
        int sensor = 0;

	while(1) {

#ifdef SINGLE_SENSOR

          _delay_ms(500);
          outputb(PIN_STATUS, 0);
          PORTD=((sensor&0x07)<<5);
          _delay_ms(100);
          if (PINC&_BV(PIN_READ)) {
            if (i2cbuffer[sensor]==1) outputb(PIN_STATUS, 1);
            i2cbuffer[sensor]=0;
          } else {
            if (i2cbuffer[sensor]==0) outputb(PIN_STATUS, 1);
            i2cbuffer[sensor]=1;
          }

          sensor++;
          if (sensor>4) sensor=0;

#ifdef DEBUG
          _delay_ms(5000);
            outputb(PIN_STATUS, 1);
          _delay_ms(100);
            outputb(PIN_STATUS, 0);
          _delay_ms(100);
#endif

#endif


	}

	return 0;
}
