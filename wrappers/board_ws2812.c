#include "main.h"
#include "stm32h723xx.h"
#include "stm32h7xx_ll_spi.h"
#include <stdint.h>

static SPI_TypeDef *driverSPI = SPI6;

void boardWS2812Init(void) {
  LL_SPI_Enable(driverSPI);
  LL_SPI_StartMasterTransfer(driverSPI);
}

void boardWS2812WriteByte(const uint8_t data) {
  while (!LL_SPI_IsActiveFlag_TXP(driverSPI)) {
  }

  LL_SPI_TransmitData8(driverSPI, data);
}
