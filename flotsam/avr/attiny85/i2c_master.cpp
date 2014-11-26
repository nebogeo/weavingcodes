//#define F_CPU 1200000UL

#include <avr/io.h>
#include <util/delay.h>
#include "tinywirem/TinyWireM.h"                  // I2C Master lib for ATTinys which use USI

typedef unsigned char u8;
typedef unsigned int u32;

#define LED PB1

void set_led_state(u8 s)
{
    if (s) PORTB|=_BV(LED);
    else PORTB&=~_BV(LED);
}

int main(void)
{
    sei();

    DDRB = 0x00;
    DDRB |= _BV( LED );
    
   
    TinyWireM.begin();

    u32 led_counter = 0;
    
    while(1) {
        TinyWireM.requestFrom(0x32,1); // Request 1 byte from slave
        u8 t = TinyWireM.receive();          // get the temperature
        
        set_led_state((led_counter++)%2);

        _delay_ms(1000);
    } 
}

