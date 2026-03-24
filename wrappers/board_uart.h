#pragma once

#include <stdint.h>

void boardUartSend_1(const uint8_t *pData, uint16_t Size);
void boardUartReceiveDMA_1(uint8_t *pData, uint16_t Size);
void boardUartReceiveDMAtoIdle_1(uint8_t *pData, uint16_t Size);

void boardUartSend_2(const uint8_t *pData, uint16_t Size);
void boardUartReceiveDMA_2(uint8_t *pData, uint16_t Size);
void boardUartReceiveDMAtoIdle_2(uint8_t *pData, uint16_t Size);

void boardUartSend_3(const uint8_t *pData, uint16_t Size);
void boardUartReceiveDMA_3(uint8_t *pData, uint16_t Size);
void boardUartReceiveDMAtoIdle_3(uint8_t *pData, uint16_t Size);

void boardUartSend_5(const uint8_t *pData, uint16_t Size);
void boardUartReceiveDMA_5(uint8_t *pData, uint16_t Size);
void boardUartReceiveDMAtoIdle_5(uint8_t *pData, uint16_t Size);

void boardUartSend_7(const uint8_t *pData, uint16_t Size);
void boardUartReceiveDMA_7(uint8_t *pData, uint16_t Size);
void boardUartReceiveDMAtoIdle_7(uint8_t *pData, uint16_t Size);

void boardUartSend_10(const uint8_t *pData, uint16_t Size);
void boardUartReceiveDMA_10(uint8_t *pData, uint16_t Size);
void boardUartReceiveDMAtoIdle_10(uint8_t *pData, uint16_t Size);

void userUartRxIdleCallback_1(uint16_t Size);
void userUartRxIdleCallback_2(uint16_t Size);
void userUartRxIdleCallback_3(uint16_t Size);
void userUartRxIdleCallback_5(uint16_t Size);
void userUartRxIdleCallback_7(uint16_t Size);
void userUartRxIdleCallback_10(uint16_t Size);

void userUartRxCpltCallback_1(void);
void userUartRxCpltCallback_2(void);
void userUartRxCpltCallback_3(void);
void userUartRxCpltCallback_5(void);
void userUartRxCpltCallback_7(void);
void userUartRxCpltCallback_10(void);
