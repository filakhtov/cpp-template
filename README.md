# C++ Template
This is template for C++ projects with test runner based on [CppUnit](https://freedesktop.org/wiki/Software/cppunit/).
It uses __GNU C++ compiler__ from [GNU Compiler Collection](https://gcc.gnu.org/) as compiler and `Makefile`s are
tested using [GNU make](https://www.gnu.org/software/make/).

## Makefile
A strict set of `CXXFLAGS` is predefined in `Makefile` and passing `DEBUG=1` to `make` command will also enable `g++`
debug mode (`-g` flag) and disable optimization (`-O` flag).

Only two _phony_ `make` targets are defined by default:
- `clean` target delegates to `tests/Makefile` which removes `tests/*.o` and `tests/tests-runner` files;
- `tests` target also delegates to `tests/Makefile` which builds `tests/tests-runner` and executes it with `compiler`
option (more information provided below).

## Testing
A number of changes are necessary in order to add more tests into test suite:

- Add test object file to `tests/Makefile` and make it a dependency for building `tests-runner`.

  Note: _Object file rules can be omitted if no additional dependencies are required to build it._

```
tests-runner: tests-runner.o foo_test.o

foo_test.o: foo_test.hpp
```

- Test file is just a standard CppUnit test definition. Simple example provided below.

  An example of `foo_test.hpp`

```
#ifndef FOO_TEST_HPP
#define FOO_TEST_HPP

#include <cppunit/extensions/HelperMacros.h>
#include <cppunit/TestFixture.h>

namespace tests
{
    class foo_test : public CppUnit::TestFixture
    {
    private:
        CPPUNIT_TEST_SUITE(foo_test);
        CPPUNIT_TEST(foo_test::test_true);
        CPPUNIT_TEST_SUITE_END();

        void test_true(void);
    };
}

#endif /* FOO_TEST_HPP */
```

  Possible implementation of `foo_test.cpp`:

```
#include <cppunit/TestAssert.h>
#include "foo_test.hpp"

void tests::foo_test::test_true(void)
{
    CPPUNIT_ASSERT(true);
}

CPPUNIT_TEST_SUITE_REGISTRATION(tests::foo_test);
CPPUNIT_TEST_SUITE_NAMED_REGISTRATION(tests::foo_test, "foo_test");
```

- Runnig `make tests` should build test suite and execute it once. This command will execute `tests-runner` with
`compiler` option, changing CppUnit output format to be compatible with IDE jump to the assertion functionality.
`setLocationFormat()` can be used in order to adjust format if required.

An individual test case can be executed using name provided to `CPPUNIT_TEST_SUITE_NAMED_REGISTRATION`, i.e.:
`./tests/tests-runner tests foo_test`.

Running `./tests/tests-runner` without arguments will execute all test cases using standard outputter of CppUnit.
