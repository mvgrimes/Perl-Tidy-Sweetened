package Perl::Tidy::Sweetend;

use strict;
use warnings;
use Perl::Tidy qw();

our $VERSION = '0.10';

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
    # Don't format the signature
    # s/^func (\w+)\s+(\([^)]*)\)? .*?$/sub $1 $3 \#__FUNC $2/gm;

    # Convert method -> sub
    s/^\s*\Kmethod\s+(\w+)\s*(\([^)]*\))?(.*?)$/sub $1 $3 \#__METHOD $2/gm;

    # warn ">>>>>>>>>\n$_";
    return $_;
}

sub postfilter {
    $_ = $_[0];

    no warnings 'uninitialized';
    # warn "========\n$_";

    # Convert func back
    # s/\W\Ksub\((.*?)\s* \#__FUNC/func($1/gm;

    # Convert sub and signature back to method
    s/^\s*\Ksub\s+(\w+)\b(.*?) *\#__METHOD( \([^)]+\))? */method $1$3$2/gm;

    # Convert sub back to method
    # s/^sub (.*?)\s* \#__METHOD/method $1/gm;

    # Remove spaces from method signature
    # s/^method (\w+) \(([^)]+?):\s/method $1 ($2:/gm;

    return $_;
}

1;

__END__

=pod

=head1 NAME

Perl::Tidy::Sweetend - Tweaks to Perl::Tidy to work with modern method systanx

=head1 DESCRIPTION

Fixes...

=head1 BACKGROUND

The L<Padre> Perl editor team developed some very interesting L<PPI> based
refactoring tools for their editor. Working with the L<Padre> team, those
routines were abstracted into L<PPIx::EditorTools> in order to make them 
available to alternative editors.

The initial implementation was developed for Vim. Pat Regan contributed
the emacs bindings. Other editor bindings are encouraged/welcome.

=head1 SEE ALSO

L<Perl::Tidy>

=head1 BUGS

Please report any bugs or suggestions at 
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Tidy-Sweetend>

=head1 AUTHOR

Mark Grimes, E<lt>mgrimes@cpan.orgE<gt>

Ideal and much of original code taken from Jonathan Swartz blog
(http://www.openswartz.com/2010/12/19/perltidy-and-method-happy-together/).

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Mark Grimes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

