#pragma once

#include "board_buzzer.h"
#include "board_dwt.h"
#include "board_led.h"
#include "board_uart.h"
#include "board_ws2812.h"
#include "board_can.h"

void boardInit(void);

void boardDelay(uint32_t ms);
