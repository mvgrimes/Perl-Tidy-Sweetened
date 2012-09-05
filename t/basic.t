use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Normal sub usage ===================================================
sub name1 {                           | sub name1 {
}                                     | }
sub name2 {                           |
}                                     | sub name2 {
~                                     | }
