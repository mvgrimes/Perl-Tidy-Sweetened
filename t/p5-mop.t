use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Simple empty class =================================================
class Point{                         | class Point {
}                                    | }
sub name3{}                          | sub name3 { }

==== Class with inheritance ===================================
class   Point3D  extends Point{       | class Point3D extends Point {
}                                    | }

==== Class with attribute ==============================================
class Point {                  | class Point {
    has  $!x;                  |     has $!x;
}                              | }
                               |
sub name3 {}                   | sub name3 { }

==== Class with attribute and trait ====================================
class Point {                  | class Point {
    has $!x  is  ro;           |     has $!x is ro;
}                              | }

==== Class with attribute with default value ===========================
class Point {                  | class Point {
    has $!x  is  ro  = 1 ;     |     has $!x is ro = 1;
}                              | }

==== Class with method ==============================================
class Point {                  | class Point {
    has $!x;                   |     has $!x;
                               |
    method set_x($x) {         |     method set_x ($x) {
        $!x = $x;              |         $!x = $x;
    }                          |     }
}                              | }
                               |
sub name3 {}                   | sub name3 { }

==== Multipart class ========================================
class A::Point {               | class A::Point {
    has $!x  is  ro  = 1 ;     |     has $!x is ro = 1;
}                              | }
