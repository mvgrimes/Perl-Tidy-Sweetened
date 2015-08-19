use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Two simple args =================================================
sub foo ($left, $right) {                 | sub foo ($left, $right) {
    return $left + $right;                |     return $left + $right;
}                                         | }

==== Ignore one arg  =================================================
sub foo ($first, $, $third) {             | sub foo ($first, $, $third) {
    return "first=$first, third=$third";  |     return "first=$first, third=$third";
}                                         | }

==== Default value  =================================================
sub foo ($left, $right = 0) {             | sub foo ($left, $right = 0) {
    return $left + $right;                |     return $left + $right;
}                                         | }

==== More complicated default  =================================================
my $auto_id = 0;                          | my $auto_id = 0;
                                          |
sub foo ($thing, $id = $auto_id++) {      | sub foo ($thing, $id = $auto_id++) {
    print "$thing has ID $id";            |     print "$thing has ID $id";
}                                         | }

==== Ignored default value =================================================
sub foo ($thing, $ = 1) {                 | sub foo ($thing, $ = 1) {
    print $thing;                         |     print $thing;
}                                         | }

==== Really ignore default value =================================================
sub foo ($thing, $=) {                    | sub foo ($thing, $=) {
    print $thing;                         |     print $thing;
}                                         | }

==== Slurpy =================================================
sub foo ($filter, @inputs) {              | sub foo ($filter, @inputs) {
    print $filter->($_) foreach @inputs;  |     print $filter->($_) foreach @inputs;
}                                         | }

==== Ignored slurpy =================================================
sub foo ($thing, @) {                     | sub foo ($thing, @) {
    print $thing;                         |     print $thing;
}                                         | }

==== Hash as an arg =================================================
sub foo ($filter, %inputs) {              | sub foo ($filter, %inputs) {
    print $filter->($_, $inputs{$_})      |     print $filter->( $_, $inputs{$_} )
        foreach sort keys %inputs;        |       foreach sort keys %inputs;
}                                         | }

==== Ignored hash =================================================
sub foo ($thing, %) {                     | sub foo ($thing, %) {
    print $thing;                         |     print $thing;
}                                         | }

==== Empty args =================================================
sub foo () {                              | sub foo () {
    return 123;                           |     return 123;
}                                         | }

==== Args and a prototype =================================================
sub foo :prototype($$) ($left, $right) {  | sub foo : prototype($$) ( $left, $right ) {
    return $left + $right;                |     return $left + $right;
}                                         | }

==== Empty hash as default value ===========================================
sub foo($x, $y={}){           | sub foo ($x, $y={}) {
    return $x+$y;             |     return $x + $y;
}                             | }

==== 5.20 annoymous sub ===============================================
$j->map(                | $j->map(
  sub($x,$ = 0) {       |     sub($x,$ = 0) {
   $x->method();        |         $x->method();
  }                     |     }
);                      | );

==== 5.20 annoymous sub 2  ===============================================
my $x = sub($x,$ = 0) { | my $x = sub($x,$ = 0) {
   $x->method();        |     $x->method();
  };                    | };

==== Simple declaraion and use =============================================
use strict;                       | use strict;
use warnings;                     | use warnings;
sub foo ($left, $right) {         | 
    return $left + $right;        | sub foo ($left, $right) {
}                                 |     return $left + $right;
say foo( $a, $b );                | }
~                                 | say foo( $a, $b );
