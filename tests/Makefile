LDFLAGS += -lcppunit

export LDFLAGS

.PHONY: all
.PHONY: clean

all: tests-runner
	./tests-runner compiler

clean:
	rm -vf *.o tests-runner

tests-runner: tests-runner.o
