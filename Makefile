CXXFLAGS += -std=c++11 -pedantic -pedantic-errors -Wall -Weffc++ -Wextra -Wcast-align -Wcast-qual -Wconversion \
    -Wdisabled-optimization -Werror -Wfloat-equal -Wformat=2 -Wformat-nonliteral -Wformat-security -Wformat-y2k \
    -Wimport -Winit-self -Winvalid-pch -Wmissing-field-initializers -Wmissing-format-attribute \
    -Wmissing-include-dirs -Wmissing-noreturn -Wpacked -Wpadded -Wpointer-arith -Wredundant-decls -Wshadow \
    -Wstack-protector -Wstrict-aliasing=2 -Wswitch-default -Wswitch-enum -Wunreachable-code -Wunused \
    -Wunused-parameter -Wvariadic-macros -Wwrite-strings
LDFLAGS += -lstdc++

#ifeq (DEBUG, 1)
CXXFLAGS += -g -O0
#endif

export CXXFLAGS LDFLAGS

.PHONY: clean
.PHONY: tests

clean:
	$(MAKE) -C tests clean
	rm -vf buildflags.txt

tests: buildflags.txt
	$(MAKE) -C tests

# This section is responsible for cleaning whole project if LDFLAGS or CXXFLAGS change since last invocation.
# This is done in order to prevent part of the objects to be built with debug flags and part without thus leading
# to various unpleasant consequences, i.e. segfaults or linking errors.
#
# Implementation is pretty straightforward: on first invocation flags will be stored into buildflags.txt file.
# On all subsequent invocations flags provided will be compared with ones stored inside of buildflags.txt and
# clean target will be executed if they differ.
define BUILD_FLAGS
CXXFLAGS=$(CXXFLAGS)
LDFLAGS=$(LDFLAGS)
endef

ifneq ($(BUILD_FLAGS), $(file < buildflags.txt))
buildflags_DEPS = clean
endif

buildflags.txt: $(buildflags_DEPS)
	$(file > buildflags.txt,$(BUILD_FLAGS))
