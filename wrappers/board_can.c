#include <stdint.h>
#include "fdcan.h"
#include "main.h"

#include "board_can.h"

void boardCanAddFilter_1(uint32_t rx_id)
{
    FDCAN_HandleTypeDef* handle          = &hfdcan1;
    static uint8_t       can_filter_idx_ = 0;
    if (can_filter_idx_ > handle->Init.StdFiltersNbr)
    {
        Error_Handler();
    }

    FDCAN_FilterTypeDef filter_cfg;
    filter_cfg.IdType       = FDCAN_STANDARD_ID;
    filter_cfg.FilterIndex  = can_filter_idx_++;
    filter_cfg.FilterType   = FDCAN_FILTER_MASK;
    filter_cfg.FilterConfig = FDCAN_FILTER_TO_RXFIFO0;
    filter_cfg.FilterID1    = rx_id << 5; // STDID放在低11位，需要左移5位
    filter_cfg.FilterID2    = 0x7FF << 5; // 掩码：匹配所有位

    if (HAL_FDCAN_ConfigFilter(handle, &filter_cfg) != HAL_OK)
    {
        Error_Handler();
    }
}

void boardCanStart_1(void)
{
    FDCAN_HandleTypeDef* handle = &hfdcan1;

    HAL_FDCAN_ConfigRxFifoOverwrite(
        handle, FDCAN_RX_FIFO0, FDCAN_RX_FIFO_OVERWRITE);
    HAL_FDCAN_Start(handle);
    HAL_FDCAN_ActivateNotification(handle, FDCAN_IT_RX_FIFO0_NEW_MESSAGE, 0);
}

void boardCanSend_1(uint32_t tx_id, const uint8_t* data, uint32_t size)
{
    FDCAN_HandleTypeDef* handle = &hfdcan1;

    FDCAN_TxHeaderTypeDef tx_header_ = {
        .Identifier          = tx_id,
        .IdType              = FDCAN_STANDARD_ID,
        .TxFrameType         = FDCAN_DATA_FRAME,
        .DataLength          = size,
        .ErrorStateIndicator = FDCAN_ESI_ACTIVE,
        .BitRateSwitch       = FDCAN_BRS_OFF,
        .FDFormat            = FDCAN_CLASSIC_CAN,
        .TxEventFifoControl  = FDCAN_STORE_TX_EVENTS,
        .MessageMarker       = 0,
    };
    HAL_FDCAN_GetTxFifoFreeLevel(handle);
    HAL_FDCAN_AddMessageToTxFifoQ(handle, &tx_header_, data);
}

//-------------------

void boardCanAddFilter_2(uint32_t rx_id)
{
    FDCAN_HandleTypeDef* handle          = &hfdcan2;
    static uint8_t       can_filter_idx_ = 0;
    if (can_filter_idx_ > handle->Init.StdFiltersNbr)
    {
        Error_Handler();
    }

    FDCAN_FilterTypeDef filter_cfg;
    filter_cfg.IdType       = FDCAN_STANDARD_ID;
    filter_cfg.FilterIndex  = can_filter_idx_++;
    filter_cfg.FilterType   = FDCAN_FILTER_MASK;
    filter_cfg.FilterConfig = FDCAN_FILTER_TO_RXFIFO0;
    filter_cfg.FilterID1    = rx_id << 5; // STDID放在低11位，需要左移5位
    filter_cfg.FilterID2    = 0x7FF << 5; // 掩码：匹配所有位

    if (HAL_FDCAN_ConfigFilter(handle, &filter_cfg) != HAL_OK)
    {
        Error_Handler();
    }
}

void boardCanStart_2(void)
{
    FDCAN_HandleTypeDef* handle = &hfdcan2;

    HAL_FDCAN_ConfigRxFifoOverwrite(
        handle, FDCAN_RX_FIFO0, FDCAN_RX_FIFO_OVERWRITE);
    HAL_FDCAN_Start(handle);
    HAL_FDCAN_ActivateNotification(handle, FDCAN_IT_RX_FIFO0_NEW_MESSAGE, 0);
}

void boardCanSend_2(uint32_t tx_id, const uint8_t* data, uint32_t size)
{
    FDCAN_HandleTypeDef* handle = &hfdcan2;

    FDCAN_TxHeaderTypeDef tx_header_ = {
        .Identifier          = tx_id,
        .IdType              = FDCAN_STANDARD_ID,
        .TxFrameType         = FDCAN_DATA_FRAME,
        .DataLength          = size,
        .ErrorStateIndicator = FDCAN_ESI_ACTIVE,
        .BitRateSwitch       = FDCAN_BRS_OFF,
        .FDFormat            = FDCAN_CLASSIC_CAN,
        .TxEventFifoControl  = FDCAN_STORE_TX_EVENTS,
        .MessageMarker       = 0,
    };
    HAL_FDCAN_GetTxFifoFreeLevel(handle);
    HAL_FDCAN_AddMessageToTxFifoQ(handle, &tx_header_, data);
}

// -------------------------------------------------

void boardCanAddFilter_3(uint32_t rx_id)
{
    FDCAN_HandleTypeDef* handle          = &hfdcan3;
    static uint8_t       can_filter_idx_ = 0;
    if (can_filter_idx_ > handle->Init.StdFiltersNbr)
    {
        Error_Handler();
    }

    FDCAN_FilterTypeDef filter_cfg;
    filter_cfg.IdType       = FDCAN_STANDARD_ID;
    filter_cfg.FilterIndex  = can_filter_idx_++;
    filter_cfg.FilterType   = FDCAN_FILTER_MASK;
    filter_cfg.FilterConfig = FDCAN_FILTER_TO_RXFIFO0;
    filter_cfg.FilterID1    = rx_id << 5; // STDID放在低11位，需要左移5位
    filter_cfg.FilterID2    = 0x7FF << 5; // 掩码：匹配所有位

    if (HAL_FDCAN_ConfigFilter(handle, &filter_cfg) != HAL_OK)
    {
        Error_Handler();
    }
}

void boardCanStart_3(void)
{
    FDCAN_HandleTypeDef* handle = &hfdcan3;

    HAL_FDCAN_ConfigRxFifoOverwrite(
        handle, FDCAN_RX_FIFO0, FDCAN_RX_FIFO_OVERWRITE);
    HAL_FDCAN_Start(handle);
    HAL_FDCAN_ActivateNotification(handle, FDCAN_IT_RX_FIFO0_NEW_MESSAGE, 0);
}

void boardCanSend_3(uint32_t tx_id, const uint8_t* data, uint32_t size)
{
    FDCAN_HandleTypeDef* handle = &hfdcan3;

    FDCAN_TxHeaderTypeDef tx_header_ = {
        .Identifier          = tx_id,
        .IdType              = FDCAN_STANDARD_ID,
        .TxFrameType         = FDCAN_DATA_FRAME,
        .DataLength          = size,
        .ErrorStateIndicator = FDCAN_ESI_ACTIVE,
        .BitRateSwitch       = FDCAN_BRS_OFF,
        .FDFormat            = FDCAN_CLASSIC_CAN,
        .TxEventFifoControl  = FDCAN_STORE_TX_EVENTS,
        .MessageMarker       = 0,
    };
    HAL_FDCAN_GetTxFifoFreeLevel(handle);
    HAL_FDCAN_AddMessageToTxFifoQ(handle, &tx_header_, data);
}

// ----------------------------------------------------

void HAL_FDCAN_RxFifo0Callback(FDCAN_HandleTypeDef* hfdcan, uint32_t RxFifo0ITs)
{
    static FDCAN_RxHeaderTypeDef rx_header_;
    static uint8_t               rx_data_[8];

    if (RxFifo0ITs & FDCAN_IT_RX_FIFO0_NEW_MESSAGE)
    {
        HAL_FDCAN_GetRxMessage(hfdcan, FDCAN_RX_FIFO0, &rx_header_, rx_data_);
        const uint32_t id  = rx_header_.Identifier;
        const uint32_t len = rx_header_.DataLength;

        if (hfdcan == &hfdcan1)
        {
            userCanCallback_1(id, len, rx_data_);
        }
        else if (hfdcan == &hfdcan2)
        {
            userCanCallback_2(id, len, rx_data_);
        }
        else if (hfdcan == &hfdcan3)
        {
            userCanCallback_3(id, len, rx_data_);
        }
    }
}
