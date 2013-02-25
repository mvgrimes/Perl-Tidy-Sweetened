use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== RT#83511 - () { rewriten as { () =========================================
method name1 () {                     | method name1 () {
}                                     | }
method name2(){                       |
}                                     | method name2 () {
~                                     | }

==== RT#83511 - same for func ================================================
func name1 () {                       | func name1 () {
}                                     | }
func name2(){                         |
}                                     | func name2 () {
~                                     | }
