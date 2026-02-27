# Makefile for Traffic Dodge game

# Tools
CC = gcc
AS = as
LD = ld

# Flags
CFLAGS = -no-pie
LDFLAGS = -lraylib -lm

# Directories
SRC_DIR = .
BUILD_DIR = build

# Source files
SOURCES = main.s data.s init.s game_loop.s input.s update.s collision.s render.s highscore.s

# Object files in the build directory
OBJECTS = $(addprefix $(BUILD_DIR)/, $(SOURCES:.s=.o))

# Output executable
TARGET = traffic_dodge

# Default target
all: $(BUILD_DIR) $(TARGET)

# Link object files
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

# Compile assembly files into build directory
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s
	$(AS) -o $@ $<

# Create build directory if not exists
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Run the game
run: $(TARGET)
	./$(TARGET)

# Clean build files
clean:
	rm -rf $(BUILD_DIR) $(TARGET)

# Rebuild everything
rebuild: clean all

.PHONY: all clean rebuild run
