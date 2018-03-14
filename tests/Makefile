LDFLAGS += -lcppunit

export LDFLAGS

.PHONY: tests
.PHONY: clean

tests: tests-runner
	./tests-runner compiler

clean:
	rm -vf *.o tests-runner

tests-runner: tests-runner.o
