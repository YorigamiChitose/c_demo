# Tools
TOOLPREFIX ?= 
CC          = $(TOOLPREFIX)gcc
AS          = $(TOOLPREFIX)as
AR          = $(TOOLPREFIX)ar
LD          = $(TOOLPREFIX)ld
OBJCOPY     = $(TOOLPREFIX)objcopy
OBJDUMP     = $(TOOLPREFIX)objdump

# Path
ROOT       ?= $(PWD)
BUILD_DIR   = $(ROOT)/build
TEMP_DIR    = $(BUILD_DIR)/temp
SRC_DIR     = $(ROOT)/src
INC_DIR     = $(ROOT)/inc

C_SRC = $(shell find $(SRC_DIR) -type f \( -name "*.s" -o -name "*.c" \))
C_INC = $(foreach inc, $(INC_DIR), -I$(inc))

C_OBJ = $(patsubst $(SRC_DIR)/%.c,$(TEMP_DIR)/%.o,$(filter %.c,$(C_SRC))) \
        $(patsubst $(SRC_DIR)/%.s,$(TEMP_DIR)/%.o,$(filter %.s,$(C_SRC)))

C_DEP = $(C_OBJ:.o=.d)

TARGET := $(BUILD_DIR)/target

# 添加 DEBUG 变量
DEBUG ?= 0
ifeq ($(DEBUG),1)
    CFLAGS += -g
endif

CFLAGS  += -Wall -Werror # C编译器选项
CFLAGS  += $(C_INC)
LDFLAGS := # 链接选项

COLOR_R  := \e[31m
COLOR_G  := \e[32m
COLOR_Y  := \e[33m
COLOR_B  := \e[34m
COLOR_P  := \e[35m
COLOR_NO := \e[0m

.PHONY: all run clean gdb

all: $(TARGET).elf

run: $(TARGET).elf
	@echo "$(COLOR_Y)RUN$(COLOR_NO)\t$(COLOR_G)$(patsubst $(BUILD_DIR)/%, %, $<)$(COLOR_NO)"
	@$(TARGET).elf $(ARGS)

$(TARGET).elf: $(C_OBJ)
	@mkdir -p $(dir $@)
	@$(CC) $^ -o $@ $(LDFLAGS)
	@echo "$(COLOR_G)LD$(COLOR_NO)\t$(COLOR_G)$(patsubst $(BUILD_DIR)/%, %, $@)$(COLOR_NO)"

$(TEMP_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -MMD -MP -c $< -o $@
	@echo "$(COLOR_Y)CC$(COLOR_NO)\t$(COLOR_R)$(patsubst $(BUILD_DIR)/%, %, $@)$(COLOR_NO)"

$(TEMP_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(dir $@)
	@$(AS) $(CFLAGS) -c $< -o $@
	@echo "$(COLOR_Y)AS$(COLOR_NO)\t$(COLOR_R)$(patsubst $(BUILD_DIR)/%, %, $@)$(COLOR_NO)"

clean:
	@rm -rf $(BUILD_DIR)
	@echo "$(COLOR_R)RM$(COLOR_NO)\t$(COLOR_R)$(BUILD_DIR)$(COLOR_NO)"

gdb: $(TARGET).elf
	@echo "$(COLOR_Y)GDB$(COLOR_NO)\t$(COLOR_G)$(patsubst $(BUILD_DIR)/%, %, $<)$(COLOR_NO)"
	@gdb $(TARGET).elf

# 包含依赖文件
-include $(C_DEP)
