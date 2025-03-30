#include "uart.h"

int main(void)
{
	// Initialize the UART
	uart_init();

	my_printf("Hello World!\n", 0);

	return 0;
}
