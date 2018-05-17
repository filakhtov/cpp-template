#include <cppunit/CompilerOutputter.h>
#include <cppunit/extensions/TestFactoryRegistry.h>
#include <cppunit/ui/text/TestRunner.h>
#include <cppunit/Test.h>
#include <cstdlib>
#include <string>
#include <vector>

using CppUnit::Test;
using CppUnit::TestFactoryRegistry;
using CppUnit::TestSuite;
using CppUnit::TextUi::TestRunner;
using std::cerr;
using std::endl;
using std::string;
using std::vector;

#define MODE_INDIVIDUAL "tests"
#define MODE_COMPILER "compiler"

vector<string> parse_arguments(const int arguments_count, char *arguments_list[])
{
    vector<string> arguments(arguments_count);

    for (int i{0}; i < arguments_count; ++i) {
        arguments.at(i) = string{arguments_list[i]};
    }

    return arguments;
}

void print_usage(const string &program_name)
{
    cerr << "Usage: " << endl;
    cerr << program_name << endl;
    cerr << program_name << " compiler [test1 [test2 [...]]]" << endl;
    cerr << program_name << " tests test1 [test2 [...]]" << endl;
}

bool are_arguments_valid(const vector<string> &arguments)
{
    return arguments.size() == 1
        || (arguments.size() >= 1 && arguments.at(1) == MODE_COMPILER)
        || (arguments.size() >= 2 && arguments.at(1) == MODE_INDIVIDUAL);
}

bool should_run_all_tests(const vector<string> &arguments)
{
    return arguments.size() == 1
        || (arguments.size() == 2 && arguments.at(1) == MODE_COMPILER);
}

void set_runner_options_for_arguments(TestRunner &runner, const vector<string> &arguments)
{
    if (arguments.at(1) == MODE_COMPILER) {
        runner.setOutputter(CppUnit::CompilerOutputter::defaultOutputter(&runner.result(), cerr));
    }
}

Test *get_full_suite(void)
{
    return TestFactoryRegistry::getRegistry().makeTest();
}

Test *get_suite_for_arguments(const vector<string> &arguments)
{
    TestFactoryRegistry &registry = TestFactoryRegistry::getRegistry();
    TestSuite* suite = new CppUnit::TestSuite("All tests");

    for (size_t i = 2; i < arguments.size(); ++i) {
        auto test_name = arguments.at(i);
        suite->addTest(registry.getRegistry(test_name).makeTest());
    }

    return suite;
}

int main(int argc, char* argv[]) {
    auto arguments = parse_arguments(argc, argv);

    if (are_arguments_valid(arguments) == false) {
        print_usage(arguments.at(0));

        return EXIT_FAILURE;
    }

    TestRunner runner;

    if (should_run_all_tests(arguments)) {
        runner.addTest(get_full_suite());
    } else {
        set_runner_options_for_arguments(runner, arguments);
        runner.addTest(get_suite_for_arguments(arguments));
    }

    return runner.run() ? EXIT_SUCCESS : EXIT_FAILURE;
}
