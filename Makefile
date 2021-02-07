CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
MACH = cortex-m3
CFLAGS = -c -mcpu=$(MACH) -mthumb -std=gnu11 -Wall -O0 -DSTM32F103xB
LDFLAGS = -mcpu=$(MACH) -mthumb --specs=nosys.specs -T STM32F103XB_FLASH.ld -Wl,-V,-Map=build/final.map

WSL = /mnt/c
WINDOWS = C:
BUILD_DIR = ./build
SRC_DIR = ./src
INC_DIR = ./include
INC_DIR += ./cmsis
INC_DIR += $(WSL)/Users/navdeep.sinha/Desktop/AWS/embedded/FreeRTOSv202012.00/FreeRTOS/Source/include
INC_DIR += $(WSL)/Users/navdeep.sinha/Desktop/AWS/embedded/FreeRTOSv202012.00/FreeRTOS/Source/portable/GCC/ARM_CM3

INC_FLAG := $(INC_DIR:%=-I%)

SRCS := $(shell find $(SRC_DIR) -name *.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)

TARGET := $(BUILD_DIR)/bluepill

print:
	@echo $(SRCS) $(OBJS)
	@echo $(INC_DIR) $(INC_FLAG)


all: $(TARGET).bin

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(TARGET).elf: $(OBJS) $(BUILD_DIR)/startup_stm32f103xb.o
	$(CC) $(LDFLAGS) $^ -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(INC_FLAG) -o $@ $<

$(BUILD_DIR)/startup_stm32f103xb.o: $(SRC_DIR)/startup_stm32f103xb.s
	$(CC) $(CFLAGS) $(INC_FLAG) -o $@ $<

compile: $(OBJS) $(BUILD_DIR)/startup_stm32f103xb.o
	@echo "compilation done..."

clean:
	rm -rf $(BUILD_DIR)/*.o $(TARGET).* $(BUILD_DIR)/final.map

load:
	# openocd -f interface/stlink-v2.cfg -f target/stm32f1x.cfg -c "program build/bluepill.elf verify reset exit"
	stm32flash -g 0x08000000 -b 115200 -w build/bluepill.bin COM7
