#include "main.h"
#include <stdint.h>

void boardDWTInit(void) {
  /* 使能DWT外设 */
  CoreDebug->DEMCR |= CoreDebug_DEMCR_TRCENA_Msk;
  /* DWT CYCCNT寄存器计数清0 */
  DWT->CYCCNT = (uint32_t)0u;
  /* 使能Cortex-M DWT CYCCNT寄存器 */
  DWT->CTRL |= DWT_CTRL_CYCCNTENA_Msk;
}

void boardDWTDelayUs(uint32_t us) {
  uint32_t ticktarget = DWT->CYCCNT + us * 480;
  while (DWT->CYCCNT < ticktarget) {
  }
}

void boardDWTDelayMs(uint32_t ms) {
  if (ms == 0) {
    return;
  } else {
    HAL_Delay(ms - 1);
  }
}
