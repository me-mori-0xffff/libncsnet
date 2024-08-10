CC = gcc
CFLAGS = -Wall -fPIC -DHAVE_CONFIG_H -march=native -mtune=native -g -flto -O3 -fforce-addr -I.
MAKE_P = make
PROG = libncsnet
STATIC_LIB = $(PROG).a
DYNAMIC_LIB = $(PROG).so
SRC_DIR = src
BIN_DIR = bin
UTILS_DIR = utils

SRCS = $(shell find $(SRC_DIR) -name '*.c')
OBJS = $(SRCS:.c=.o)

TESTS_DIR = tests

all: endmsg

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

$(STATIC_LIB): $(OBJS)
	ar rcs $@ $(OBJS)

$(DYNAMIC_LIB): $(OBJS)
	$(CC) -shared -o $@ $(OBJS)

libraries: $(STATIC_LIB) $(DYNAMIC_LIB)

tests: libraries
	cd $(TESTS_DIR);$(MAKE_P);cd ..

utils: libraries
	cd $(UTILS_DIR);$(MAKE_P);cd ..

clean:
	rm -rf config.status config.log autom4te.cache Makefile config.h $(OBJS) $(STATIC_LIB) $(DYNAMIC_LIB)
	cd $(TESTS_DIR);$(MAKE_P) clean;cd ..
	cd $(UTILS_DIR);$(MAKE_P) clean;cd ..

distclean: clean
	rm -f configure

endmsg: libraries tests utils
	@echo ""
	@echo ""
	@echo "COMPILE COMPLETED"
	@echo "The library and utils has been successfully compiled!"
	@echo "Check \"libncsnet.a\", \"libncsnet.so\", and \"utils/\""
	@echo ""
	@echo ""


.PHONY: all clean distclean libraries tests utils endmsg
