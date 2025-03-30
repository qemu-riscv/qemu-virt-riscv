// See LICENSE for license details.

#include "uart.h"
// #include "platform.h"

void uart_init(void)
{
	// Enable 8 byte FIFO
	UART_FCR = 0x81;

	// set 0x0080 to UART.LCR to enable DLL and DLM write
	// configure baud rate
	UART_LCR = 0x80;

	// System clock 100 MHz, 115200 baud rate
	// divisor = clk_freq / (16 * Baud)
	UART_DLL = 100 * 1000 * 1000u / (16u * 115200u) % 0x100u;
	UART_DLM = 100 * 1000 * 1000u / (16u * 115200u) >> 8;

	// 8-bit data, no parity
	UART_LCR = 0x0003u;
	UART_LCR = 0x0000001F;

	// Enable read IRQ
	UART_IER = 0x0001u;
	UART_IER = 0x00000011;

	my_printf("Uart is working\n", 0);
}

void uart_send(unsigned char data)
{
	// wait until THR empty
	while ((UART_LSR & TRANSMITTER_EMPTY) != TRANSMITTER_EMPTY)
		;

	UART_THR = data;
}

void putch(uint8_t ch)
{
	// REGUINT(DMEM_BASE) = ch;
	uart_send(ch);
}

void print_num(uint32_t num, uint32_t base)
{
	if (num == 0)
		return;
	print_num(num / base, base);
	putch("0123456789abcdef"[num % base]);
}

void my_printf(const char *s, uint32_t num)
{
	int i = 0;
	// va_list va_ptr;
	// va_start(va_ptr, s);
	while (s[i] != '\0') {
		if (s[i] != '%')
			putch(s[i++]);
		else
			switch (s[++i]) {
			case 'd':
			{
				// printDeci(va_arg(va_ptr,int));
				if (num == 0)
					putch('0');
				else
					print_num(num, 10);
				i++;
				continue;
			}
			case 'p':
			{
				// printDeci(va_arg(va_ptr,int));
				putch('0');
				putch('x');
				if (num == 0)
					putch('0');
				else
					print_num(num, 16);
				i++;
				continue;
			}
			case 'x':
			{
				// printDeci(va_arg(va_ptr,int));
				if (num <= 0xf)
					putch('0');
				if (num == 0)
					putch('0');
				else
					print_num(num, 16);
				i++;
				continue;
			}
			case 's':
			{
				my_printf((char *)num, 0);
				i++;
				continue;
			}
			default:
			{
				i++;
				continue;
			}
			}
	}
	// va_end(va_ptr);
}
