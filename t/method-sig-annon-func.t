use lib 't/lib';
use TidierTests;
TidierTests::do_tests( \*DATA );

__DATA__
==== TODO Annoymous func (GH#4) ===============================================
my $foo = func ($x,:$y) { $self->xyzzy($x,$y) }; | my $foo = func ($x,:$y) { $self->xyzzy($x,$y) };

==== TODO Annoymous func (GH#4) ===============================================
my $foo = { bar => 1, baz => func ($x,:$y) { $self->xyzzy($x,$y) } }; | my $foo = {
                                                                      |     bar => 1,
                                                                      |     baz => func ($x,:$y) { $self->xyzzy( $x, $y ) }
                                                                      | };
                                                                      | 
