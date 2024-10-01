# Directories
INCLUDE_DIR := ./includes
BUILD_DIR := ./build
SRC_DIR := ./src
LIB_DIR := ./libs

LIBS := $(wildcard $(LIB_DIR)/*.lib)

# Source and object files
ASM_SRCS := $(wildcard $(SRC_DIR)/*.asm)
ASM_OBJS := $(patsubst $(SRC_DIR)/%.asm,$(BUILD_DIR)/%.o,$(ASM_SRCS))

EXE := $(BUILD_DIR)/app.exe

# Assembler and linker commands
ASM := nasm
ASM_FLAGS := -f win64 -g
LINKER := polink
LINKER_FLAGS := /ENTRY:_start /SUBSYSTEM:WINDOWS

.PHONY: all clean clean-artifacts run size
all: compile link clean-artifacts run size

compile: $(ASM_OBJS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@echo "Compiling..."
	@$(ASM) $(ASM_FLAGS) -o $@ $<

link:
	@echo "Linking..."
	@$(LINKER) $(LINKER_FLAGS) -out:$(EXE) $(ASM_OBJS)


run: $(EXE)
	@echo ""
	@echo "================[ RUN ]================"
	@echo "Running the executable..."
	@$(EXE); echo " > Return code: $$?"

size:
	@echo -n " > Size of EXE: " && wc -c < $(EXE) | tr -d '\n' && echo

clean:
	@rm -f $(BUILD_DIR)/*.exe
