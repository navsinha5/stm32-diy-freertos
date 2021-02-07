#include "FreeRTOS.h"
#include "task.h"
#include "led.h"
#include "usart1.h"

TaskHandle_t sendHelloHandle = NULL;
TaskHandle_t sendWorldHandle = NULL;

void sendHello(void *pvParameters);
void sendWorld(void *pvParameters);

int main(void){
    /* initialize led and usart1 */
    ledInit();
    initUsart();

    /* create task */
    xTaskCreate(sendHello, "hello-uart", configMINIMAL_STACK_SIZE, NULL, 2, &sendHelloHandle);
    xTaskCreate(sendWorld, "world-uart", configMINIMAL_STACK_SIZE, NULL, 2, &sendWorldHandle);

    /* start task schedular */
    vTaskStartScheduler();

    /* should never come here */
    while(1);
}


void sendHello(void *pvParameters){
    while(1){
        send('h');
        send('e');
        send('l');
        send('l');
        send('o');
        send(' ');
        taskYIELD();
    }

    vTaskDelete(NULL);
}


void sendWorld(void *pvParameters){
    while(1){
        send('w');
        send('o');
        send('r');
        send('l');
        send('d');
        send('!');
        send('\r');
        send('\n');
        taskYIELD();
    }

    vTaskDelete(NULL);
}