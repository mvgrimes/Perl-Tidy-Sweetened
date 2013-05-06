package Perl::Tidy::Sweetened::Pluggable;

# ABSTRACT: Simple object to facilitate a pluggable filter architecture

use strict;
use warnings;

our $VERSION = '0.20';

sub new {
    my ( $class, %args ) = @_;
    return bless {%args}, $class;
}

sub filters { return ( $_[0]->{filters} ||= [] ) }

sub add_filter {
    my $self = shift;
    push @{ $self->filters }, @_;
}

sub prefilter {
    my ( $self, $code ) = @_;
    for my $filter ( @{ $self->filters } ) {
        $code = $filter->prefilter($code);
    }
    return $code;
}

sub postfilter {
    my ( $self, $code ) = @_;
    for my $filter ( @{ $self->filters } ) {
        $code = $filter->postfilter($code);
    }
    return $code;
}

1;

__END__

=pod

=head1 NAME

Perl::Tidy::Sweetened::Pluggable - Simple object to facilitate a pluggable filter architecture

=head1 VERSION

version 0.20

=head1 SYNOPSIS

    our $plugins = Perl::Tidy::Sweetened::Pluggable->new();

    $plugins->add_filter(
        Perl::Tidy::Sweetened::Keyword::SubSignature->new(
            keyword => 'method',
            marker  => 'METHOD',
        ) );

    $plugins->prefilter( $code );
    $plugins->postfilter( $code );

=head1 DESCRIPTION

Builds a pluggable, chainable list of filters.

=head1 THANKS

See L<Perl::Tidy::Sweetened>

=head1 BUGS

Please report any bugs or suggestions at
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Tidy-Sweetened>

=head1 AUTHOR

Mark Grimes, E<lt>mgrimes@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Mark Grimes, E<lt>mgrimes@cpan.orgE<gt>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
