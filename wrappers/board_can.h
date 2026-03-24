#pragma once


#include <stdint.h>

void boardCanAddFilter_1(uint32_t rx_id);
void boardCanStart_1(void);
void boardCanSend_1(uint32_t tx_id, const uint8_t* data, uint32_t size);

void boardCanAddFilter_2(uint32_t rx_id);
void boardCanStart_2(void);
void boardCanSend_2(uint32_t tx_id, const uint8_t* data, uint32_t size);

void boardCanAddFilter_3(uint32_t rx_id);
void boardCanStart_3(void);
void boardCanSend_3(uint32_t tx_id, const uint8_t* data, uint32_t size);

void userCanCallback_1(uint32_t id, uint32_t len, uint8_t* data);
void userCanCallback_2(uint32_t id, uint32_t len, uint8_t* data);
void userCanCallback_3(uint32_t id, uint32_t len, uint8_t* data);
