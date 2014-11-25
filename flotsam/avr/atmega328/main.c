#ifndef F_CPU
#define F_CPU 16000000UL
#endif

#include <avr/io.h>
#include <util/delay.h>
#include <stdlib.h>
#include <avr/interrupt.h>

#include "I2C_slave.h"

// buffer used to convert integer to string
char buffer[3];



void set_led_state(u8 s)
{
    if (s) PORTB|=_BV(LED);
    else PORTB&=~_BV(LED);
}

void init_uart(uint16_t baudrate){

	uint16_t UBRR_val = (F_CPU/16)/(baudrate-1);

	UBRR0H = UBRR_val >> 8;
	UBRR0L = UBRR_val;

	UCSR0B |= (1<<TXEN0) | (1<<RXEN0) | (1<<RXCIE0); // UART TX (Transmit - senden) einschalten
	UCSR0C |= (1<<USBS0) | (3<<UCSZ00); //Modus Asynchron 8N1 (8 Datenbits, No Parity, 1 Stopbit)
}

void uart_putc(unsigned char c){

	while(!(UCSR0A & (1<<UDRE0))); // wait until sending is possible
	UDR0 = c; // output character saved in c
}

void uart_puts(char *s){
	while(*s){
		uart_putc(*s);
		s++;
	}
}

int main(void){
	
	init_uart(57600);
	I2C_init(0x32); // initalize as slave with address 0x32
	
	// allow interrupts
	sei();
	
	while(1){
		// convert receiver buffer index 0 to character array and send it via UART
		itoa(rxbuffer[0], buffer, 10);
		uart_puts(buffer);
		_delay_ms(1000);
	}
	
	return 0;
}
