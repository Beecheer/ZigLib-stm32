#include "main.h"
#include "stm32h7xx_hal.h"
#include <stdint.h>

void boardInit(void) { MX_Main_Init(); }

void boardDelay(uint32_t ms) { HAL_Delay(ms - 1); }
