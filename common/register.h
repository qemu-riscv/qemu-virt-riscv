#pragma once

#include <stdint.h>

// define the macros for register access
#define REG_TYPE(address, type) (*(type *)(address))

#define REG_V8 (address) REG_TYPE(address, volatile uint8_t)
#define REG_V16(address) REG_TYPE(address, volatile uint16_t)
#define REG_V32(address) REG_TYPE(address, volatile uint32_t)
#define REG_V64(address) REG_TYPE(address, volatile uint64_t)

#define REG_8 (address) REG_TYPE(address, uint8_t)
#define REG_16(address) REG_TYPE(address, uint16_t)
#define REG_32(address) REG_TYPE(address, uint32_t)
#define REG_64(address) REG_TYPE(address, uint64_t)

#define REG(base, offset, type) REG_TYPE(base + offset, type)


#define BIT(n) (1 << (n))
