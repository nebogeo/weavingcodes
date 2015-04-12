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

void set_led_state(unsigned char s)
{
    if (s) PORTB|=_BV(PIN_STATUS);
    else PORTB&=~_BV(PIN_STATUS);
}

void output(unsigned int pin, unsigned char s)
{
    if (s) PORTB|=_BV(pin);
    else PORTB&=~_BV(pin);
}

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))

int main(void){
	I2C_init(0x32<<1); // initalize as slave with address 0x32

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

    output(PIN_MUXA, 1);
    output(PIN_MUXB, 0);
    output(PIN_MUXC, 0);
    output(PIN_CS0, 0);
    output(PIN_CS1, 1);
    output(PIN_CS2, 1);

    for (int i=0; i<0xFF; i++) {
        i2cbuffer[i]=0;
    }

    int chip = 0;
    int mux = 0;

	while(1)
    {



        if (PINC&_BV(PIN_READ)) {
            output(PIN_STATUS, 0);
        } else {
            output(PIN_STATUS, 1);
        }

//        mux++;
//        _delay_ms(5000);

/*        output(PIN_STATUS, 0);
        _delay_ms(5000);
        output(PIN_STATUS, 1);
        _delay_ms(5000);
*/

	}

	return 0;
}
