use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Simple method usage =================================================
method name1{                         | method name1 {
}                                     | }
sub name2{                            |
}                                     | sub name2 {
~                                     | }

==== Method with signature ==============================================
method name1 (class: $that) {         | method name1 (class: $that) {
}                                     | }
method name2( :$arg1, :$arg2 ){       |
}                                     | method name2 ( :$arg1, :$arg2 ) {
sub name3 {}                          | }
~                                     | sub name3 { }

==== Functions =============================================
func morning ($name) {            | func morning ($name) {
    say "Hi $name";               |     say "Hi $name";
}                                 | }

