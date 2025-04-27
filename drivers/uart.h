// See LICENSE for license details.

#pragma once

#include "common/register.h"

// RBR: Receiver Buffer register [Read, LCR[7] == 0]
#define RBR 0x0u

// THR: Transmitter Holding register [Write, LCR[7] == 0]
#define THR 0x0u

// IER: Interrupt enable register [Read/Write, LCR[7] == 0]
#define IER 0x1u

// IIR: Interrupt identification register [Read]
#define IIR 0x2u

// FCR: FIFO control register [Write, Read only when LCR[7] == 1]
#define FCR 0x2u

// LCR: Line control register [Read/Write]
#define LCR 0x3u

// MCR: Modem control register [Read/Write]
#define MCR 0x4u

// LSR: Line status register [Read/Write]
#define LSR 0x5u

// MSR: Modem status register [Read/Write]
#define MSR 0x6u

// SCR: Scratch register [Read/Write]
#define SCR 0x7u

// DLL: Divisor latch (least significant byte) register [RD/WR, LCR[7] == 1]
#define DLL 0x0u

// DLM: Divisor latch (most significant byte) register [RD/WR, LCR[7] == 1]
#define DLM 0x1u

// FCR flags
#define FIFO_ENABLE         BIT(0)
#define THR_EMPTY           BIT(5)
#define TRANSMITTER_EMPTY   BIT(6)

#define UART_THR    REG_TYPE(UART_BASE + THR, uint8_t)
#define UART_FCR    REG_TYPE(UART_BASE + FCR, uint8_t)
#define UART_LCR    REG_TYPE(UART_BASE + LCR, uint8_t)
#define UART_IER    REG_TYPE(UART_BASE + IER, uint8_t)

#define UART_LSR    REG_TYPE(UART_BASE + LSR, uint8_t)

#define UART_DLL    REG_TYPE(UART_BASE + DLL, uint8_t)
#define UART_DLM    REG_TYPE(UART_BASE + DLM, uint8_t)

// UART APIs
void uart_init(void);
void putch(uint8_t ch);
void uart_send(uint8_t data);
void my_printf(const char *s, uint32_t num);
