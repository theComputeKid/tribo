# Run config for the example.
export TRIBO_VERBOSE ?= 0
EXAMPLE_INPUT_FILE := examples/simple.ini
EXAMPLE_OUTPUT_FILE := $(TMP_DIR)/simple.txt
EXAMPLE_RUN_CMD := $(OUT_APP) $(EXAMPLE_INPUT_FILE) $(EXAMPLE_OUTPUT_FILE) --bench
ifneq ($(OS),Windows_NT)
export LD_LIBRARY_PATH=$(BIN_DIR)
else
EXAMPLE_RUN_CMD := $(EXAMPLE_RUN_CMD:/=\)
endif
