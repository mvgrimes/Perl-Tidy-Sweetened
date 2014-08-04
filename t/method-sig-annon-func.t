use lib 't/lib';
use Test::More;
use TidierTests;

TODO: {
    local $TidierTests::TODO = 'Annoymous functions are not supported yet';
    TidierTests::do_tests( \*DATA );
}

__DATA__
==== Annoymous func (GH#4) ===============================================
my $foo = func ($x,:$y) { $self->xyzzy($x,$y) }; | my $foo = func ($x,:$y) { $self->xyzzy($x,$y) };

==== Annoymous func (GH#4) ===============================================
my $foo = { bar => 1, baz => func ($x,:$y) { $self->xyzzy($x,$y) } }; | my $foo = {
                                                                      |     bar => 1,
                                                                      |     baz => func ($x,:$y) { $self->xyzzy( $x, $y ) }
                                                                      | };
                                                                      | 
