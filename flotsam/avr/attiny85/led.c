#include <avr/io.h>
#include <util/delay.h>

typedef unsigned char u8;
typedef unsigned int u32;

#define LED PB0

void set_led_state(u8 s)
{
    if (s) PORTB|=_BV(LED);
    else PORTB&=~_BV(LED);
}

int main(void)
{
    DDRB = 0x00;
    DDRB |= _BV( LED );

    // activate pull up resistors
    //PORTB|=_BV(LEFT_EYE);

    u32 ledtime=0;
    while(1) {
        set_led_state((ledtime++)%2500<1200);
    } 
}

