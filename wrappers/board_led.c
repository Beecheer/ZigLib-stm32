#include "main.h"
#include "stm32h7xx_hal_gpio.h"

void boardLedOn_1(void) {
  HAL_GPIO_WritePin(POWER_PWM_GPIO_Port, POWER_PWM_Pin, GPIO_PIN_RESET);
}

void boardLedOff_1(void) {
  HAL_GPIO_WritePin(POWER_PWM_GPIO_Port, POWER_PWM_Pin, GPIO_PIN_SET);
}

void boardLedToggle_1(void) {
  HAL_GPIO_TogglePin(POWER_PWM_GPIO_Port, POWER_PWM_Pin);
}

void boardLedOn_2(void) {
  HAL_GPIO_WritePin(POWER_24V_1_GPIO_Port, POWER_24V_1_Pin, GPIO_PIN_RESET);
}

void boardLedOff_2(void) {
  HAL_GPIO_WritePin(POWER_24V_1_GPIO_Port, POWER_24V_1_Pin, GPIO_PIN_SET);
}

void boardLedToggle_2(void) {
  HAL_GPIO_TogglePin(POWER_PWM_GPIO_Port, POWER_PWM_Pin);
}

void boardLedOn_3(void) {
  HAL_GPIO_WritePin(POWER_24V_2_GPIO_Port, POWER_24V_2_Pin, GPIO_PIN_RESET);
}

void boardLedOff_3(void) {
  HAL_GPIO_WritePin(POWER_24V_2_GPIO_Port, POWER_24V_2_Pin, GPIO_PIN_SET);
}

void boardLedToggle_3(void) {
  HAL_GPIO_TogglePin(POWER_PWM_GPIO_Port, POWER_PWM_Pin);
}
