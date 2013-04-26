package Perl::Tidy::Sweetened;

# ABSTRACT: Tweaks to Perl::Tidy to support some syntactic sugar

use 5.010;
use strict;
use warnings;
use Perl::Tidy qw();

our $VERSION = '0.19';

# Regex to match balanced parans. Reproduced from Regexp::Common to avoid
# adding a non-core dependency.
#   $RE{balanced}{-parens=>'()'};
# The (?-1) construct requires 5.010
our $Clause = '(?:((?:\((?:(?>[^\(\)]+)|(?-1))*\))))';

sub perltidy {
    return Perl::Tidy::perltidy(
        prefilter  => \&prefilter,
        postfilter => \&postfilter,
        @_
    );
}

sub prefilter {
    $_ = $_[0];

    no warnings 'uninitialized';

    # Convert func xxxx (signature) -> sub
    s{^\s*\K            # okay to have leading whitespace (preserve)
      func   \s+        # the "func" keyword
      (\w+)  \s*        # the function name ($1)
      (?:$Clause)?      # optional parameter list (multi-line ok) ($2 in Clause)
      (.*?)             # anything else (ie, comments) ($3)
      $
     }{sub $1 $3 \#__FUNC @{[ escape_params( $2 ) ]}}gxm;

    # Convert method (signature) -> sub
    # encode multi-line parameter lists into one with escaped "\n"
    s{^\s*\K            # ok to have leading whitespace (preserve)
      method \s+        # the "method" keyword
      (\w+)  \s*        # the method name ($1)
      (?:$Clause)?      # optional parameter list (multi-line ok) ($2 in Clause)
      (.*?)             # anything else (ie, comments) ($3)
      $
    }{sub $1 $3 \#__METHOD @{[ escape_params( $2 ) ]}}xgm;

    return $_;
}

sub postfilter {
    $_ = $_[0];

    no warnings 'uninitialized';

    # Convert back to func
    s{^\s*\K              # preserve leading whitespace
      sub \s+             # func was converted to sub
      (\w+)\b             # the function name and a break ($1)
      (.*?) [ ]*          # anything originally following the declaration ($2)
      \#__FUNC            # our magic token
      (\s $Clause)?       # optional parameter list ($3 & $4 in Clause)
      [ ]*                # trailing spaces
    }{func $1@{[ unescape_params( $3 ) ]}$2}xgm;

    # Check to see if tidy turned it into "sub name\n{ #..."
    s{^\s*\K            # preserve leading whitespace
      sub \s+           # method was converted to sub
      (\w+)\n           # the method name and a newline ($1)
      \s* \{(.*?) [ ]*  # opening brace on a newline followed orig comments ($2)
      \#__FUNC          # our magic token
      (\s $Clause)?     # optional parameter list ($3 & $4 in Clause)
      [ ]*              # trailing spaces
    }{func $1@{[ unescape_params( $3 ) ]} \{$2}gmx;

    # Convert back to method
    s{^\s*\K            # preserve leading whitespace
      sub \s+           # method was convert to sub
      (\w+)\b           # the method name and a word break ($1)
      (.*?)[ ]*         # anything originally following the declaration ($2)
      \#__METHOD        # out magic token
      (\s $Clause)?     # option parameter list ($3 & $4 in Clause)
      [ ]*              # trailing spaces
    }{method $1@{[ unescape_params( $3 ) ]}$2}gmx;

    # Check to see if tidy turned it into "sub name\n{ #..."
    s{^\s*\K            # preserve leading whitespace
      sub \s+           # method was converted to sub
      (\w+)\n           # the method name and a newline ($1)
      \s* \{(.*?) [ ]*  # opening brace on newline followed orig comments ($2)
      \#__METHOD        # our magic token
      (\s $Clause)?     # optional parameter list ($3 & $4 in Clause)
      [ ]*              # trailing spaces
    }{method $1@{[ unescape_params( $3 ) ]} \{$2}gmx;

    return $_;
}

# Convert any newline into \n
sub escape_params {
    my ($params) = @_;
    return $params unless defined $params;
    $params =~ s{ \n }{\\n}xgm;
    return $params;
}

# Convert any \n into newlines
sub unescape_params {
    my ($params) = @_;
    return $params unless defined $params;
    $params =~ s{ \\n }{\n}xgm;
    return $params;
}

1;

__END__

=pod

=head1 NAME

Perl::Tidy::Sweetened - Tweaks to Perl::Tidy to support some syntactic sugar

=head1 VERSION

version 0.19

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

C<Perl::Tidy::Sweetened> attempts to support the syntax outlined in:

=over

=item * Method::Signature::Simple

=item * MooseX::Method::Signatures

=item * MooseX::Declare

=back

=head1 SEE ALSO

L<Perl::Tidy>

The idea and much of original code taken from Jonathan Swartz'
L<blog|http://www.openswartz.com/2010/12/19/perltidy-and-method-happy-together/>.

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
