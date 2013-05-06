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

==== Simple methods with underscores  ===================================
method name_1{                        | method name_1 {
}                                     | }

==== Method with signature ==============================================
method name1 (class: $that) {         | method name1 (class: $that) {
}                                     | }
method name2( :$arg1, :$arg2 ){       |
}                                     | method name2 ( :$arg1, :$arg2 ) {
sub name3 {}                          | }
~                                     | sub name3 { }

==== Functions ==========================================================
func morning ($name) {            | func morning ($name) {
    say "Hi $name";               |     say "Hi $name";
}                                 | }

==== Functions with underscore in name ==================================
func morn_ing ($name) {           | func morn_ing ($name) {
    say "Hi $name";               |     say "Hi $name";
}                                 | }

==== Functions with multi-line paramaters ================================
func morning ( Str :$name,        | func morning ( Str :$name,
               Int :$age,         |                Int :$age,
             ) {                  |              ) {
    say "Hi $name";               |     say "Hi $name";
}                                 | }

==== With trailing comments =================================================
method name1{# Trailing comment       | method name1 {    # Trailing comment
}                                     | }
sub name2{  # Trailing comment        |
}                                     | sub name2 {    # Trailing comment
~                                     | }

==== With attribs trailing comments =================================================
method name1 :Attrib(Arg) {# comment  | method name1 : Attrib(Arg) {    # comment
}                                     | }
sub name2 :Attrib(Arg) {  # comment   |
}                                     | sub name2 : Attrib(Arg) {    # comment
~                                     | }
