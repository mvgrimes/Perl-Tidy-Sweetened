use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Simple class defn =================================================
class Person {                        | class Person {
  has 'name' => ( is => 'rw' );       |     has 'name' => ( is => 'rw' );
}                                     | }

==== TODO: Class defn with Moose =============================================
class Person using Moose {            | class Person using Moose {
  has 'name' => ( is => 'rw' );       |     has 'name' => ( is => 'rw' );
}                                     | }

==== Class defn with version  ===========================================
class Person 1.2 {                    | class Person 1.2 {
  has 'name' => ( is => 'rw' );       |     has 'name' => ( is => 'rw' );
}                                     | }

==== Role defn =================================================
role NamedThing {                     | role NamedThing {
  has 'balance' => ( is => 'rw' );    |     has 'balance' => ( is => 'rw' );
}                                     | }

==== Class with role =================================================
class Person with NamedThing;         | class Person with NamedThing;

==== Class that extends another ======================================
class Employee extends Person {       | class Employee extends Person {
   has job_title => (is=>'ro');       |     has job_title => ( is => 'ro' );
}                                     | }

==== TODO: Class that extends and role ======================================
class Employee extends Person with Employment {  | class Employee extends Person with Employment {
   has job_title => (is=>'ro');                  |     has job_title => ( is => 'ro' );
}                                                | }

==== Class with lexical_has ======================================
class Employee extends Person {        | class Employee extends Person {
   lexical_has job_title => (is=>'ro');|     lexical_has job_title => ( is => 'ro' );
}                                      | }

==== Class defn with method ============================================
class BankAccount {                     | class BankAccount {
    has 'balance' => ( is => 'rw' );    |     has 'balance' => ( is => 'rw' );
    method deposit (Num $amount){       |
    $self->inc_balance( $amount );      |     method deposit (Num $amount) {
    }                                   |         $self->inc_balance($amount);
}                                       |     }
~                                       | }

==== TODO: Class with attribute ================================================
class Person :mutable {                | class Person : mutable {
   lexical_has job_title => (is=>'ro');|     lexical_has job_title => ( is => 'ro' );
}                                      | }
