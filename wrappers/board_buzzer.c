#include "main.h"
#include "stm32h7xx_hal_tim.h"
#include "tim.h"
#include <stdint.h>

void boardBuzzerStart(const uint32_t freq) {
  __HAL_TIM_SET_AUTORELOAD(&htim12, freq);
  __HAL_TIM_SET_COMPARE(&htim12, TIM_CHANNEL_2, freq / 2);
  HAL_TIM_PWM_Start(&htim12, TIM_CHANNEL_2);
}

void boardBuzzerStop(void) { HAL_TIM_PWM_Stop(&htim12, TIM_CHANNEL_2); }
