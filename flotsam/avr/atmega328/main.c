#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <avr/interrupt.h>

#include "I2C_slave.h"

// buffer used to convert integer to string
char buffer[3];

#define LED PB0

void set_led_state(unsigned char s)
{
    if (s) PORTB|=_BV(LED);
     else PORTB&=~_BV(LED);
}

#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))

int main(void){	
	I2C_init(0x32<<1); // initalize as slave with address 0x32
	
	// allow interrupts
	sei();

    DDRD |= 0xff;
    PORTD = 0xff;

    for (int i=0; i<0xFF; i++) {
        i2cbuffer[i]=0;
    }

    int led_counter = 0;
	while(1)
    {
//        if (rxbuffer[0]!=0) {
//            DDRB |= _BV( LED ); 
//            set_led_state(1);       
//        }

		_delay_ms(500);
//        set_led_state(0);
//        PORTD = 0x00;
		_delay_ms(500);
//        PORTD = 0xff;

//        set_led_state(1);
	}
	
	return 0;
}
