//#define F_CPU 1200000UL
#define I2C_SLAVE_ADDRESS 0x45 // the 7-bit address

#include <avr/io.h>
#include <util/delay.h>
#include "tinywires/TinyWireS.h"                  // I2C Master lib for ATTinys which use USI

typedef unsigned char u8;
typedef unsigned int u32;

#define LED PB1

void set_led_state(u8 s)
{
    if (s) PORTB|=_BV(LED);
    else PORTB&=~_BV(LED);
}

//////////////////////////////////////////////////////////////

#ifndef TWI_RX_BUFFER_SIZE
#define TWI_RX_BUFFER_SIZE ( 16 )
#endif


volatile uint8_t i2c_regs[] =
{
    0xDE, 
    0xAD, 
    0xBE, 
    0xEF, 
};
// Tracks the current register pointer position
volatile u8 reg_position;
const u8 reg_size = sizeof(i2c_regs);

/**
 * This is called for each read request we receive, never put more than one byte of data (with TinyWireS.send) to the 
 * send-buffer when using this callback
 */
void requestEvent()
{  
    TinyWireS.send(i2c_regs[reg_position]);
    // Increment the reg position on each read, and loop back to zero
    reg_position++;
    if (reg_position >= reg_size)
    {
        reg_position = 0;
    }
}

/**
 * The I2C data received -handler
 *
 * This needs to complete before the next incoming transaction (start, data, restart/stop) on the bus does
 * so be quick, set flags for long running tasks to be called from the mainloop instead of running them directly,
 */
void receiveEvent(uint8_t howMany)
{
    if (howMany < 1)
    {
        // Sanity-check
        return;
    }
    if (howMany > TWI_RX_BUFFER_SIZE)
    {
        // Also insane number
        return;
    }

    reg_position = TinyWireS.receive();
    howMany--;
    if (!howMany)
    {
        // This write was only to set the buffer for next read
        return;
    }
    while(howMany--)
    {
        i2c_regs[reg_position] = TinyWireS.receive();
        reg_position++;
        if (reg_position >= reg_size)
        {
            reg_position = 0;
        }
    }
}


int main(void)
{
    sei();

    DDRB = 0x00;
    DDRB |= _BV( LED );
    DDRB |= _BV( PB3 );
    


    // activate pull up resistors
    //PORTB|=_BV(LEFT_EYE);
    
    TinyWireS.begin(I2C_SLAVE_ADDRESS);
    TinyWireS.onReceive(receiveEvent);
    TinyWireS.onRequest(requestEvent);
    //TinyWireM.begin();                    // initialize I2C lib

  
    //TinyWireM.requestFrom(0x01,1); // Request 1 byte from slave
    //u8 t = TinyWireM.receive();          // get the temperature


    u32 led_counter = 0;
    while(1) {
        TinyWireS_stop_check();
        set_led_state((led_counter++)%10000>5000);
    } 
}

