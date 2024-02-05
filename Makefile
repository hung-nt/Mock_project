# Reset
NC='\033[0m'       # No color

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White


CXX ?= g++
CXXFLAGS := -std=c++11 -Wall -Wextra -Werror -pedantic -g

# path #
SRC = Src
BUILD = build
BIN = bin

# executable # 
BIN_NAME = runner

# code lists #
SRCS = $(shell find $(SRC) -name '*.cpp' | sort -k 1nr | cut -f2-)
# Set the object files
OBJS = $(SRCS:$(SRC)/%.cpp=$(BUILD)/%.o)

# flags #
RELEASE_FLAGS = -std=c++11 -Wall -Wextra
INCS = -I $(SRC)
LIBS = -lstdc++ -lm

.PHONY: default
default: build

.PHONY: build
build: dirs
	@$(MAKE) --no-print-directory all

.PHONY: dirs
dirs:
	@mkdir -p $(dir $(OBJS))
	@mkdir -p $(BIN)

.PHONY: clean
clean:
	@echo $(BRed)"Deleting directories"$(NC)
	@$(RM) -r $(BUILD)/*
	@$(RM) -r $(BIN)/*

.PHONY: run
run: $(BIN)/$(BIN_NAME)
run: dirs
	@echo $(BGreen)"Runnning: $(BIN)/$(BIN_NAME)"$(BWhite)
	@./$(BIN)/$(BIN_NAME)
	@echo -e $(NC)

.PHONY: all
all: $(BIN)/$(BIN_NAME)

.PHONY: valgrind
valgrind: dirs $(BIN)/$(BIN_NAME)
	@valgrind --tool=memcheck --leak-check=yes --show-reachable=yes --track-origins=yes --num-callers=20 $(BIN)/$(BIN_NAME)

# Creation of the executable
$(BIN)/$(BIN_NAME): $(OBJS)
	@echo $(BBlue)"Linking: $@"$(NC)
	$(CXX) $(OBJS) -o $@ ${LIBS}

# Source file rules
$(BUILD)/%.o: $(SRC)/%.cpp
	@echo $(BYellow)"Compiling: $< -> $@ "$(NC)
	$(CXX) $(CXXFLAGS) $(INCS) -c $< -o $@