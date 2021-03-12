#include "FreeRTOS.h"
#include "task.h"
#include "led.h"
#include "usart1.h"
#include "stm32f1xx.h"

volatile uint16_t delay = 2000U;

TaskHandle_t toggleLedHandle = NULL;

void xToggleLed(void *pvParameters);

int main(void){
    /* initialize led and usart1 */
    ledInit();
    initUsart();

    /* create task */
    xTaskCreate(xToggleLed, "toggle-led", configMINIMAL_STACK_SIZE, NULL, 2, &toggleLedHandle);

    /* start task schedular */
    vTaskStartScheduler();

    /* should never come here */
    while(1);
}


void xToggleLed(void *pvParameters){
    while(1){
        toggle();
        vTaskDelay(pdMS_TO_TICKS(delay));
    }

    vTaskDelete(NULL);
}


/* USART1 global interrupt handler implementation */
void USART1_IRQHandler(void){
    /* check if data is available to read */
    if(USART1->SR & USART_SR_RXNE){
        uint8_t value = USART1->DR;
        switch(value){
            case 'a':
                delay = 200U;
                break;
            
            case 'b':
                delay = 500U;
                break;

            case 'c':
                delay = 1000U;
                break;

            default:
                break;
        }
        send(value);
    }
}
