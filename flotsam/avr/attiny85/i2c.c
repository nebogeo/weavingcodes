#include <avr/io.h>
#include <util/delay.h>
#include "usi_i2c_slave.h"

typedef unsigned char u8;
typedef unsigned int u32;

#define LED PB1

void set_led_state(u8 s)
{
    if (s) PORTB|=_BV(LED);
    else PORTB&=~_BV(LED);
}

extern char usi_i2c_slave_address;
extern char* USI_Slave_register_buffer[];

int main(void)
{
    DDRB = 0x00;
    DDRB |= _BV( LED );

    set_led_state(0);

    // activate pull up resistors
    //PORTB|=_BV(LEFT_EYE);

	//sei();
    
    USI_I2C_Init(0x55);

    char t=0;
	USI_Slave_register_buffer[0] = &t;
	USI_Slave_register_buffer[1] = &t;
	USI_Slave_register_buffer[2] = &t;
	USI_Slave_register_buffer[3] = &t;
	USI_Slave_register_buffer[4] = &t;
	USI_Slave_register_buffer[5] = &t;
	USI_Slave_register_buffer[6] = &t;
	USI_Slave_register_buffer[7] = &t;


    //TinyWireM.requestFrom(0x01,1); // Request 1 byte from slave
    //u8 t = TinyWireM.receive();          // get the temperature

    u32 led_counter=0;
    while(1) {
        //set_led_state((led_counter++)%10000>5000);
    } 
}

