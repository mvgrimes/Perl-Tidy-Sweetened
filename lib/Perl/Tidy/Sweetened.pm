package Perl::Tidy::Sweetened;

# ABSTRACT: Tweaks to Perl::Tidy to support some syntactic sugar

use 5.010;
use strict;
use warnings;
use Perl::Tidy qw();

our $VERSION = '0.24';

use Perl::Tidy::Sweetened::Pluggable;
use Perl::Tidy::Sweetened::Keyword::Block;
use Perl::Tidy::Sweetened::Variable::Twigils;

our $plugins = Perl::Tidy::Sweetened::Pluggable->new();

# Create a subroutine filter for:
#    func foo (Int $i) returns (Bool) {}
# where both the parameter list and the returns type are optional
$plugins->add_filter(
    Perl::Tidy::Sweetened::Keyword::Block->new(
        keyword     => 'func',
        marker      => 'FUNC',
        replacement => 'sub',
        clauses     => [ 'PAREN?', '(returns \s* PAREN)?' ],
    ) );

# Create a subroutine filter for:
#    method foo (Int $i) returns (Bool) {}
# where both the parameter list and the returns type are optional
$plugins->add_filter(
    Perl::Tidy::Sweetened::Keyword::Block->new(
        keyword     => 'method',
        marker      => 'METHOD',
        replacement => 'sub',
        clauses     => [ 'PAREN?', '(returns \s* PAREN)?' ],
    ) );

# Create a subroutine filter for:
#    class Foo extends Bar {
#    class Foo with Bar, Baz {
# where both the extends and with are optional
$plugins->add_filter(
    Perl::Tidy::Sweetened::Keyword::Block->new(
        keyword     => 'class',
        marker      => 'CLASS',
        replacement => 'package',
        clauses     => [ '(with(\s+\w+)*)?', '(extends \s+ \w+)?' ],
    ) );

# Create a twigil filter for:
#    $!variable_name
$plugins->add_filter(
    Perl::Tidy::Sweetened::Variable::Twigils->new(
        twigil => '$!',
        marker => 'TWG_BANG',
    ) );

sub perltidy {
    return Perl::Tidy::perltidy(
        prefilter  => sub { $plugins->prefilter( $_[0] ) },
        postfilter => sub { $plugins->postfilter( $_[0] ) },
        @_
    );
}

1;

__END__

=pod

=head1 NAME

Perl::Tidy::Sweetened - Tweaks to Perl::Tidy to support some syntactic sugar

=head1 VERSION

version 0.24

=head1 DESCRIPTION

There are a number of modules on CPAN that allow users to write their classes
with a more "modern" syntax. These tools eliminate the need to shift off
C<$self>, can support type checking and offer other improvements.
Unfortunately, they can break the support tools that the Perl community has
come to rely on. This module attempts to work around those issues.

The module uses
L<Perl::Tidy>'s C<prefilter> and C<postfilter> hooks to support C<method> and
C<func> keywords, including the (possibly multi-line) parameter lists. This is
quite an ugly hack, but it is the recommended method of supporting these new
keywords (see the 2010-12-17 entry in the Perl::Tidy
L<CHANGES|https://metacpan.org/source/SHANCOCK/Perl-Tidy-20120714/CHANGES>
file). B<The resulting formatted code will leave the parameter lists untouched.>

C<Perl::Tidy::Sweetened> attempts to support the syntax outlined in the
following modules, but most of the new syntax styles should work:

=over

=item * p5-mop

=item * Method::Signature::Simple

=item * MooseX::Method::Signatures

=item * MooseX::Declare

=back

=head1 SEE ALSO

L<Perl::Tidy>

=head1 THANKS

The idea and much of original code taken from Jonathan Swartz'
L<blog|http://www.openswartz.com/2010/12/19/perltidy-and-method-happy-together/>.

Kent Fredric refactored the code into the pluggable architecture. Very nice
work, thank you.

=head1 BUGS

Please report any bugs or suggestions at
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Tidy-Sweetened>

=head1 AUTHOR

Mark Grimes, E<lt>mgrimes@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Mark Grimes, E<lt>mgrimes@cpan.orgE<gt>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
