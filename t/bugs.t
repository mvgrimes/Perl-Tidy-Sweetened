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

==== RT#84868 - prototype with () ============================================
func nm (Any $a where qr{(foo)}) {    | func nm (Any $a where qr{(foo)}) {
}                                     | }
func name2(){                         |
}                                     | func name2 () {
~                                     | }

==== RT#84868 - prototype with multiple () ==================================
func nm (Any $a where qr{(f)(o)}) {   | func nm (Any $a where qr{(f)(o)}) {
}                                     | }
func name2(){                         |
}                                     | func name2 () {
~                                     | }

==== RT#84868 - Multiple line signatures =====================================
method nm (Str $bar,                 | method nm (Str $bar,
           Int $foo where { $_>(0) } |            Int $foo where { $_>(0) }
          ) {                        |           ) {
}                                    | }

==== RT#84868 - Multiple line signatures w/ comment =========================
method nm (Str $bar,                   | method nm (Str $bar,
           Int $foo where { $_ > (0) } |            Int $foo where { $_ > (0) }
          ) {   # Fun stuff            |           ) {    # Fun stuff
}                                      | }

==== RT#85076 - handle returns() with signature  ============================
method foo ( File :$file! ) returns(Bool) {  | method foo ( File :$file! ) returns(Bool) {
}                                            | }

==== RT#85076 - handle returns() ============================================
method foo returns(Bool) {             | method foo returns(Bool) {
}                                      | }

==== RT#94633 - class WORD::WORD {} ========================================
class WORD::WORD {            | class WORD::WORD {
}                             | }
                              |
class WORD {                  | class WORD {
}                             | }
                              |
sub mysub:ATTRIBUTE {         | sub mysub : ATTRIBUTE {
}                             | }

==== RT#106398 - Long single line subs ================================
sub test ($param) {$param->test->that->breaks->perltidysweetened} | sub test ($param) { $param->test->that->breaks->perltidysweetened }

==== RT#106398 - Long single line subs w/o params ===========================
sub test {$param->this->is->a->test->that->breaks->perltidysweetened} | sub test {
~                                                                     |     $param->this->is->a->test->that->breaks
~                                                                     |       ->perltidysweetened;
~                                                                     | }

==== TODO: RT#106464 - MooseX::Role::Parameterized ============================
method _path => sub { $path };   | method _path => sub { $path };

