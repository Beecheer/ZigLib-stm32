#include "main.h"
#include "stm32h7xx_hal_uart.h"
#include "stm32h7xx_hal_uart_ex.h"
#include "usart.h"

#include "board_uart.h"

void boardUartSend_1(const uint8_t *pData, uint16_t Size) {
  HAL_UART_Transmit_DMA(&huart1, pData, Size);
}
void boardUartReceiveDMA_1(uint8_t *pData, uint16_t Size) {
  HAL_UART_Receive_DMA(&huart1, pData, Size);
  __HAL_DMA_DISABLE_IT(huart1.hdmarx, DMA_IT_HT);
}
void boardUartReceiveDMAtoIdle_1(uint8_t *pData, uint16_t Size) {
  HAL_UARTEx_ReceiveToIdle_DMA(&huart1, pData, Size);
  __HAL_DMA_DISABLE_IT(huart1.hdmarx, DMA_IT_HT);
}

void boardUartSend_2(const uint8_t *pData, uint16_t Size) {
  HAL_UART_Transmit_DMA(&huart2, pData, Size);
}
void boardUartReceiveDMA_2(uint8_t *pData, uint16_t Size) {
  HAL_UART_Receive_DMA(&huart2, pData, Size);
  __HAL_DMA_DISABLE_IT(huart2.hdmarx, DMA_IT_HT);
}
void boardUartReceiveDMAtoIdle_2(uint8_t *pData, uint16_t Size) {
  HAL_UARTEx_ReceiveToIdle_DMA(&huart2, pData, Size);
  __HAL_DMA_DISABLE_IT(huart2.hdmarx, DMA_IT_HT);
}

void boardUartSend_3(const uint8_t *pData, uint16_t Size) {
  HAL_UART_Transmit_DMA(&huart3, pData, Size);
}
void boardUartReceiveDMA_3(uint8_t *pData, uint16_t Size) {
  HAL_UART_Receive_DMA(&huart3, pData, Size);
  __HAL_DMA_DISABLE_IT(huart3.hdmarx, DMA_IT_HT);
}
void boardUartReceiveDMAtoIdle_3(uint8_t *pData, uint16_t Size) {
  HAL_UARTEx_ReceiveToIdle_DMA(&huart3, pData, Size);
  __HAL_DMA_DISABLE_IT(huart3.hdmarx, DMA_IT_HT);
}

void boardUartSend_5(const uint8_t *pData, uint16_t Size) {
  HAL_UART_Transmit_DMA(&huart5, pData, Size);
}
void boardUartReceiveDMA_5(uint8_t *pData, uint16_t Size) {
  HAL_UART_Receive_DMA(&huart5, pData, Size);
  __HAL_DMA_DISABLE_IT(huart5.hdmarx, DMA_IT_HT);
}
void boardUartReceiveDMAtoIdle_5(uint8_t *pData, uint16_t Size) {
  HAL_UARTEx_ReceiveToIdle_DMA(&huart5, pData, Size);
  __HAL_DMA_DISABLE_IT(huart5.hdmarx, DMA_IT_HT);
}

void boardUartSend_7(const uint8_t *pData, uint16_t Size) {
  HAL_UART_Transmit_DMA(&huart7, pData, Size);
}
void boardUartReceiveDMA_7(uint8_t *pData, uint16_t Size) {
  HAL_UART_Receive_DMA(&huart7, pData, Size);
  __HAL_DMA_DISABLE_IT(huart7.hdmarx, DMA_IT_HT);
}
void boardUartReceiveDMAtoIdle_7(uint8_t *pData, uint16_t Size) {
  HAL_UARTEx_ReceiveToIdle_DMA(&huart7, pData, Size);
  __HAL_DMA_DISABLE_IT(huart7.hdmarx, DMA_IT_HT);
}

void boardUartSend_10(const uint8_t *pData, uint16_t Size) {
  HAL_UART_Transmit_DMA(&huart10, pData, Size);
}
void boardUartReceiveDMA_10(uint8_t *pData, uint16_t Size) {
  HAL_UART_Receive_DMA(&huart10, pData, Size);
  __HAL_DMA_DISABLE_IT(huart10.hdmarx, DMA_IT_HT);
}
void boardUartReceiveDMAtoIdle_10(uint8_t *pData, uint16_t Size) {
  HAL_UARTEx_ReceiveToIdle_DMA(&huart10, pData, Size);
  __HAL_DMA_DISABLE_IT(huart10.hdmarx, DMA_IT_HT);
}

void HAL_UARTEx_RxEventCallback(UART_HandleTypeDef *huart, uint16_t Size) {
  if (huart == &huart1) {
    userUartRxIdleCallback_1(Size);
  } else if (huart == &huart2) {
    userUartRxIdleCallback_2(Size);
  } else if (huart == &huart3) {
    userUartRxIdleCallback_3(Size);
  } else if (huart == &huart5) {
    userUartRxIdleCallback_5(Size);
  } else if (huart == &huart7) {
    userUartRxIdleCallback_7(Size);
  } else if (huart == &huart10) {
    userUartRxIdleCallback_10(Size);
  }
}

void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart) {
  if (huart == &huart1) {
    userUartRxCpltCallback_1();
  } else if (huart == &huart2) {
    userUartRxCpltCallback_2();
  } else if (huart == &huart3) {
    userUartRxCpltCallback_3();
  } else if (huart == &huart5) {
    userUartRxCpltCallback_5();
  } else if (huart == &huart7) {
    userUartRxCpltCallback_7();
  } else if (huart == &huart10) {
    userUartRxCpltCallback_10();
  }
}
