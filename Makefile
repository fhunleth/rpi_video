# Variables to override
#
# CC            C compiler
# CROSSCOMPILE	crosscompiler prefix, if any
# CFLAGS	compiler flags for compiling all C files
# LDFLAGS	linker flags for linking all binaries
# VIDEOCORE_DIR path to VideoCore libraries. This defaults to "/opt/vc"

# Initialize some variables if not set
LDFLAGS ?=
CFLAGS ?= -O2 -Wall -Wextra -Wno-unused-parameter

# Check that we're on a supported build platform
ifeq ($(CROSSCOMPILE),)
    # Not crosscompiling, so check that we're on Linux.
    ifneq ($(shell uname -s),Linux)
        $(warning rpi_video only works on Linux on a Raspberry Pi. Crosscompilation)
        $(warning is supported by defining at least $$CROSSCOMPILE. See Makefile for)
        $(warning details. If using Nerves, this should be done automatically.)
        $(warning .)
        $(warning Skipping C compilation unless targets explicitly passed to make.)
	DEFAULT_TARGETS = priv
    else
        # On the Raspberry Pi, the VideoCore libraries aren't in the standard
        # locations in /usr/include and /usr/lib.
	VIDEOCORE_DIR ?= /opt/vc

        ifneq ($(wildcard $(VIDEOCORE_DIR)),)
	    CFLAGS += -I$(VIDEOCORE_DIR)/include
            CFLAGS += -I$(VIDEOCORE_DIR)/include/interface/vcos/pthreads
            CFLAGS += -I$(VIDEOCORE_DIR)/include/interface/vmcs_host/linux
            CFLAGS += -I$(VIDEOCORE_DIR)/include/interface/vchiq_arm
            LDFLAGS += -L$(VIDEOCORE_DIR)/lib
        else
            $(warning rpi_video only works on Linux on a Raspberry Pi. The VideoCore)
            $(warning libraries were not found, so assuming this is a non-Raspberry)
            $(warning build and skipping C compilation. If this is wrong, check the)
            $(warning Makefile and define VIDEOCORE_DIR.)
	    DEFAULT_TARGETS = priv
        endif
    endif
endif
DEFAULT_TARGETS ?= priv priv/rpi_video

# Link in the VideoCore libraries
LDFLAGS += -lilclient -lopenmaxil -lvcilcs -lbrcmGLESv2 -lbrcmEGL -lbcm_host\
	   -lvchostif -lvcfiled_check -lvchiq_arm -lvcos -lpthread -lrt -lm

CFLAGS += -DEGL_SERVER_DISPMANX -DHAVE_VMCS_CONFIG -DOMX_SKIP64BIT\
	  -DTV_SUPPORTED_MODE_NO_DEPRECATED -DUSE_VCHIQ_ARM -DVCHI_BULK_ALIGN=1\
	  -DVCHI_BULK_GRANULARITY=1 -D__VIDEOCORE4__

SRC=$(wildcard src/*.c)
OBJ=$(SRC:.c=.o)

.PHONY: all clean

all: $(DEFAULT_TARGETS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

priv:
	mkdir -p priv

priv/rpi_video: $(OBJ)
	$(CC) $^ $(LDFLAGS) -o $@

clean:
	rm -f priv/rpi_video $(OBJ)
