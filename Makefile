CC = g++
CXXFLAGS += -std=c++11 -pedantic -pedantic-errors -Wall -Weffc++ -Wextra -Wcast-align -Wcast-qual -Wconversion \
    -Wdisabled-optimization -Werror -Wfloat-equal -Wformat=2 -Wformat-nonliteral -Wformat-security -Wformat-y2k \
    -Wimport -Winit-self -Winvalid-pch -Wmissing-field-initializers -Wmissing-format-attribute  -Wmissing-include-dirs \
    -Wmissing-noreturn -Wpacked -Wpadded -Wpointer-arith -Wredundant-decls -Wshadow -Wstack-protector \
    -Wstrict-aliasing=2 -Wswitch-default -Wswitch-enum -Wunreachable-code -Wunused -Wunused-parameter \
    -Wvariadic-macros -Wwrite-strings

#ifeq (DEBUG, 1)
CXXFLAGS += -g -O
#endif

export CXXFLAGS CC

.PHONY: clean
.PHONY: tests

clean:
	$(MAKE) -C tests clean

tests:
	$(MAKE) -C tests
