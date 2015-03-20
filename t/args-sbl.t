use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA, '-sbl');

__DATA__
==== RT#102815 - ignores -sbl =========================================
sub name1 () {                     | sub name1 ()
}                                  | {
sub name2()                        | }
{                                  |
}                                  | sub name2 ()
~                                  | {
~                                  | }

==== what if indented ==================================================
sub name1 () {                     | sub name1 ()
~                                  | {
sub name2()                        |
{                                  |     sub name2 ()
}                                  |     {
~                                  |     }
}                                  | }
