package Perl::Tidy::Sweetened::Keyword::SubSignature;

# ABSTRACT: Perl::Tidy::Sweetened filter plugin to define new subroutine keywords

use 5.010;    # Needed for balanced parens matching with qr/(?-1)/
use strict;
use warnings;
use Carp;

our $VERSION = '0.20';

# Regex to match balanced parans. Reproduced from Regexp::Common to avoid
# adding a non-core dependency.
#   $RE{balanced}{-parens=>'()'};
# The (?-1) construct requires 5.010
our $Clause = '(?:((?:\((?:(?>[^\(\)]+)|(?-1))*\))))';

sub new {
    my ( $class, %args ) = @_;
    croak 'keyword not specified' if not exists $args{keyword};
    croak 'marker not specified'  if not exists $args{marker};
    return bless {%args}, $class;
}

sub keyword { return $_[0]->{keyword} }
sub marker  { return $_[0]->{marker} }

sub emit_sub {
    my ( $self, $subname, $signature, $prelude, $returns ) = @_;

    # Store the signature and returns() for later use
    my $id = $self->{counter}++;
    $self->{store}->{$id} = { signature => $signature, returns => $returns };

    return sprintf 'sub %s %s #__%s %s', $subname, $prelude, $self->marker, $id;
}

sub emit_keyword {
    my ( $self, $subname, $padding, $prelude, $id ) = @_;

    # Get the signature and returns() from store
    my $signature = $self->{store}->{$id}->{signature} // '';
    my $returns   = $self->{store}->{$id}->{returns}   // '';
    $signature = ' ' . $signature if length $signature;
    $returns   = ' ' . $returns   if length $returns;

    return sprintf '%s %s%s%s%s%s',
      $self->keyword,
      $subname,
      $signature,
      $returns,
      $padding,
      $prelude;
}

sub prefilter {
    my ( $self, $code ) = @_;
    my $keyword = $self->keyword;

    $code =~ s{
        ^\s*\K                    # okay to have leading whitespace (preserve)
        $keyword             \s+  # the "func/method" keyword
        (?<subname> \w+)     \s*  # the function name
        (?<params> $Clause)? \s*  # optional parameter list (multi-line ok)
        (?<returns> returns \s* $Clause )?
                                  # optional returns(...)
        (?<prelude> .*?)          # anything else (ie, comments) including brace
        $
    }{
        $self->emit_sub( $+{subname}, $+{params}, $+{prelude}, $+{returns} )
    }egmx;

    return $code;
}

sub postfilter {
    my ( $self, $code ) = @_;
    my $marker = $self->marker;

    # Convert back to method
    $code =~ s{
        ^\s*\K                 # preserve leading whitespace
        sub               \s+  # keyword was convert to sub
        (?<subname> \w+ ) \b   # the method name and a word break
        (?<prelude> .*? ) \s*  # anything orig following the declaration
        \#__$marker \s+        # our magic token
        (?<id> \d+)            # our sub identifier
        [ ]*                   # trailing spaces (not all whitespace)
    }{
        $self->emit_keyword( $+{subname}, '', $+{prelude}, $+{id} );
    }egmx;

    # Check to see if tidy turned it into "sub name\n{ #..."
    $code =~ s{
        ^\s*\K                   # preserve leading whitespace
        sub                 \s+  # method was converted to sub
        (?<subname> \w+)\n  \s*  # the method name and a newline
        \{ (?<prelude> .*?) [ ]* # opening brace on newline followed orig comments
        \#__$marker         \s+  # our magic token
        (?<id> \d+)              # our sub identifier
        [ ]*                     # trailing spaces (not all whitespace)
    }{
        $self->emit_keyword( $+{subname}, ' \{', $+{prelude}, $+{id} );
    }egmx;

    return $code;
}

1;

__END__

=pod

=head1 NAME

Perl::Tidy::Sweetened::Keyword::SubSignature - Perl::Tidy::Sweetened filter plugin to define new subroutine keywords

=head1 VERSION

version 0.20

=head1 SYNOPSIS

    our $plugins = Perl::Tidy::Sweetened::Pluggable->new();

    $plugins->add_filter(
        Perl::Tidy::Sweetened::Keyword::SubSignature->new(
            keyword => 'method',
            marker  => 'METHOD',
        ) );

=head1 DESCRIPTION

This is a Perl::Tidy::Sweetened filter which enables the definition of
arbitrary keywords for subroutines.

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
