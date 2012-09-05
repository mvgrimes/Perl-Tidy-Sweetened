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

==== With paramater typing =============================================
method morning (Str $name) {            | method morning (Str $name) {
    $self->say("Hi ${name}!");          |     $self->say("Hi ${name}!");
}                                       | }

==== With params with constraints ======================================
method hello (:$age where { $_ > 0 }) { | method hello (:$age where { $_ > 0 }) {
}                                       | }

==== Multiple line signatures ==========================================
method name1 (Str $bar,                 | method name1 (Str $bar,
              Int $foo where { $_ > 0 } |               Int $foo where { $_ > 0 }
             ) {                        |              ) {
}                                       | }

==== Multiple line signatures w/ comment  ===============================
method name1 (Str $bar,                 | method name1 (Str $bar,
              Int $foo where { $_ > 0 } |               Int $foo where { $_ > 0 }
             ) {   # Fun stuff          |              ) { # Fun stuff
}                                       | }
