ASM_SOURCES := $(wildcard *.asm)
C_TEST_SOURCES := $(wildcard test.c)
OBJ_DIR := obj
BIN_DIR := bin
EXECUTABLE := $(BIN_DIR)/test
ASM_OBJECTS := $(addprefix $(OBJ_DIR)/, $(notdir $(ASM_SOURCES:.asm=.o)))
C_TEST_OBJECTS := $(addprefix $(OBJ_DIR)/, $(notdir $(C_TEST_SOURCES:.c=.o)))
VPATH := src:src/helpers:test

all: $(OBJ_DIR) $(BIN_DIR) $(EXECUTABLE)

$(EXECUTABLE): $(ASM_OBJECTS) $(C_TEST_OBJECTS)
	gcc -no-pie -g -m64 -o $@ $^

$(OBJ_DIR)/%.o: %.asm
	yasm -f elf64 -g dwarf2 $< -o $@

$(OBJ_DIR)/%.o: %.c
	gcc -g -m64 -c $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

run: $(EXECUTABLE)
	@./$(EXECUTABLE)

debug: $(EXECUTABLE)
	gdb $(EXECUTABLE)

clean:
	rm -f $(ASM_OBJECTS) $(C_TEST_OBJECTS) $(EXECUTABLE)

fresh: clean all
