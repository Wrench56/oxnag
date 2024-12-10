# Directories
INCLUDE_DIR := ./includes
BUILD_DIR := ./build
SRC_DIR := ./src
LIB_DIR := ./libs/win

LIBS := $(wildcard $(LIB_DIR)/*.lib)

# Source and object files
ASM_SRCS := $(wildcard $(SRC_DIR)/**/*.asm) $(wildcard $(SRC_DIR)/*.asm)
ASM_OBJS := $(wildcard $(BUILD_DIR)/*.o)

EXE := $(BUILD_DIR)/oxnag.exe

# Assembler and linker commands
ASM := nasm
ASM_FLAGS := -f win64 -g
LINKER := link
LINKER_FLAGS := /ENTRY:_start /SUBSYSTEM:WINDOWS /MACHINE:X64 /DEBUG

.PHONY: all clean clean-artifacts run size
all: check_duplicates compile link clean-artifacts run size

check_duplicates:
	@duplicate_files=$$(find $(SRC_DIR) -type f -name '*.asm' -exec basename {} \; | sort | uniq -d); \
	if [ -n "$$duplicate_files" ]; then \
		echo -e "\033[31mError\033[0m: Duplicate source filenames detected:"; \
		echo " > $$duplicate_files"; \
		exit 1; \
	fi

compile:
	@$(foreach SRC,$(ASM_SRCS), \
		$(ASM) $(ASM_FLAGS) $(SRC) -o $(BUILD_DIR)/$(notdir $(patsubst %.asm,%.o,$(SRC))); \
		echo "Compiled $(SRC)";)

link:
	@echo "Linking..."
	@$(LINKER) $(LINKER_FLAGS) -out:$(EXE) $(ASM_OBJS) $(LIBS)


run: $(EXE)
	@echo ""
	@echo "================[ RUN ]================"
	@echo "Running the executable..."
	@$(EXE); echo " > Return code: $$?"

size:
	@echo -n " > Size of EXE: " && wc -c < $(EXE) | tr -d '\n' && echo

clean:
	@rm -f $(BUILD_DIR)/*.exe
