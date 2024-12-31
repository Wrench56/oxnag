# Directories
INCLUDE_DIR := ./includes
BUILD_DIR := ./build
SRC_DIR := ./src
COMMON_DIR := $(SRC_DIR)/common

# Default Platform Detection (fallback)
ifeq ($(OS),Windows_NT)
    PLATFORM := win
else
    PLATFORM := nix
endif

# Override PLATFORM Based on Explicit Target
ifneq ($(filter win,$(MAKECMDGOALS)),)
    PLATFORM := win
endif
ifneq ($(filter nix,$(MAKECMDGOALS)),)
    PLATFORM := nix
endif

# Default Display Backend
ifeq ($(PLATFORM),win)
    DISPLAY_BACKEND := dswind
else
    DISPLAY_BACKEND := x11
endif

# Override Display Backend Based on Explicit Target
ifneq ($(filter x11,$(MAKECMDGOALS)),)
    DISPLAY_BACKEND := x11
endif
ifneq ($(filter wayland,$(MAKECMDGOALS)),)
    DISPLAY_BACKEND := wayland
endif
ifneq ($(filter dswind,$(MAKECMDGOALS)),)
    DISPLAY_BACKEND := dswind
endif

# Platform-Specific Settings
ifeq ($(PLATFORM),win)
    PLATFORM_DIR := $(SRC_DIR)/win
    EXE := $(BUILD_DIR)/oxnag.exe
    ASM := nasm
    ASM_FLAGS := -f win64 -g
    LINKER := link
    LINKER_FLAGS := /NOLOGO /ENTRY:_start /SUBSYSTEM:WINDOWS /MACHINE:X64 /DEBUG -out:$(EXE)
    LIB_DIR := ./libs/win
    LIBS := $(wildcard $(LIB_DIR)/*.lib)
else
    PLATFORM_DIR := $(SRC_DIR)/nix
    EXE := $(BUILD_DIR)/oxnag
    ASM := nasm
    ASM_FLAGS := -f elf64 -g
    LINKER := ld
    LINKER_FLAGS := -o $(EXE) -e _start -lc -lGL
    LIB_DIR := ./libs/nix
    LIBS := $(wildcard $(LIB_DIR)/*.a)
endif

# Display Backend Specific Sources
ifeq ($(DISPLAY_BACKEND),x11)
    PLATFORM_SRCS += $(wildcard $(PLATFORM_DIR)/display/X11/*.asm)
endif
ifeq ($(DISPLAY_BACKEND),wayland)
    PLATFORM_SRCS += $(wildcard $(PLATFORM_DIR)/display/wayland/*.asm)
endif

# Source and Object Files
COMMON_SRCS := $(wildcard $(SRC_DIR)/*.asm) $(wildcard $(COMMON_DIR)/*.asm)
PLATFORM_SRCS += $(wildcard $(PLATFORM_DIR)/*.asm)
ifeq ($(PLATFORM),nix)
    PLATFORM_SRCS += $(wildcard $(PLATFORM_DIR)/posix/*.asm)
endif
UTIL_SRCS := $(wildcard $(SRC_DIR)/utils/*.asm)
ALL_SRCS := $(COMMON_SRCS) $(PLATFORM_SRCS) $(UTIL_SRCS)
ALL_OBJS := $(patsubst %.asm, $(BUILD_DIR)/%.o, $(notdir $(ALL_SRCS)))

# Targets
.PHONY: all clean run size help win nix x11 wayland dswind compile link banner

# Default Target
all: banner $(PLATFORM)

# Banner Target
banner:
	@echo "===============[ OXNAG ]==============="
	@echo "Platform: $(PLATFORM)"
	@if [ -d "$(BUILD_DIR)" ]; then \
		printf "Build Directory: \033[32mExists\033[0m\n"; \
	else \
		printf "Build Directory: \033[31mMissing\033[0m\n"; \
	fi
	@if command -v $(ASM) > /dev/null 2>&1; then \
		echo "NASM Version: $$( $(ASM) -v | sed 's/NASM version \([0-9]*\.[0-9]*\.[0-9]*\).*/\1/' | head -n 1 )"; \
	else \
		printf "NASM Version: \033[31mMissing\033[0m\n"; \
	fi
	@echo "Display Backend: $(DISPLAY_BACKEND)"
	@echo ""

# Duplicate Filename Check
check_duplicates:
	@duplicate_files=$$(find $(SRC_DIR) -type f -name '*.asm' -exec basename {} \; | sort | uniq -d); \
	if [ -n "$$duplicate_files" ]; then \
		printf "\033[31mError\033[0m: Duplicate source filenames detected:\n"; \
		echo " > $$duplicate_files"; \
		exit 1; \
	fi

# Compile All Sources
compile:
	@echo "=============[ COMPILING ]============="
	@for SRC in $(ALL_SRCS); do \
		OBJ=$(BUILD_DIR)/$$(basename $${SRC%.asm}.o); \
		$(ASM) $(ASM_FLAGS) $$SRC -o $$OBJ; \
		echo "Compiled: $$SRC"; \
	done

# Link Object Files
link:
	@printf "\n==============[ LINKING ]==============\n"
	@$(LINKER) $(LINKER_FLAGS) $(ALL_OBJS) $(LIBS)

# Run Executable
run: $(EXE)
	@echo ""
	@printf "\n================[ RUN ]================\n"
	@echo "Running the executable..."
	@$(EXE); echo " > Return code: $$?"

# Show Executable Size
size:
	@echo -n " > Size of EXE: " && wc -c < $(EXE) | tr -d '\n' && echo

# Clean Build Directory
clean:
	@echo "Cleaning build directory..."
	@rm -f $(BUILD_DIR)/*

# Help Message
help:
	@: $(info $(HELP_STRING))

define HELP_STRING
usage: make <target>
targets:
 * banner               Show project banner
 * win                  Build for Windows
 * nix                  Build for *nix
 * x11                  Build with X11 display backend (default for *nix)
 * wayland              Build with Wayland display backend
 * dswind               Build with dswind backend (default for Windows)
 * compile              Compile all sources (current platform)
 * link                 Link all object files (current platform)
 * run                  Run the application
 * size                 Fetch the size of the application
 * clean                Clean the build directory
 * help                 Show this menu
endef

# Windows Build
win: banner check_duplicates compile link run size

# *nix Build
nix: banner check_duplicates compile link run size

# X11 Display Backend Build
x11: banner check_duplicates compile link run size

# Wayland Display Backend Build
wayland: banner check_duplicates compile link run size

# dswind Display Backend Build
dswind: banner check_duplicates compile link run size
