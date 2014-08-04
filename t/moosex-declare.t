use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Simple class defn =================================================
class BankAccount {                   | class BankAccount {
  has 'balance' => ( is => 'rw' );    |     has 'balance' => ( is => 'rw' );
}                                     | }

==== Class defn with method ============================================
class BankAccount {                     | class BankAccount {
    has 'balance' => ( is => 'rw' );    |     has 'balance' => ( is => 'rw' );
    method deposit (Num $amount){       |
    $self->inc_balance( $amount );      |     method deposit (Num $amount) {
    }                                   |         $self->inc_balance($amount);
}                                       |     }
~                                       | }

==== Multipart class =====================================================
class A::Point {               | class A::Point {
    has $!x  is  ro  = 1 ;     |     has $!x is ro = 1;
}                              | }

==== Class with attrs (GH#5) =============================================
class A::Point is dirty {      | class A::Point is dirty {
    has $!x  is  ro  = 1 ;     |     has $!x is ro = 1;
}                              | }
