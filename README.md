# NAME

Perl::Tidy::Sweetened - Tweaks to Perl::Tidy to support some syntactic sugar

# VERSION

version 0.18

# DESCRIPTION

There are a number of modules on CPAN that allow users to write their classes
with a more "modern" syntax. These tools eliminate the need to shift off
`$self`, can support type checking and offer other improvements.
Unfortunately, they can break the support tools that the Perl community has
come to rely on. This module attempts to work around those issues.

The module uses
[Perl::Tidy](http://search.cpan.org/perldoc?Perl::Tidy)'s `prefilter` and `postfilter` hooks to support `method` and
`func` keywords, including the (possibly multi-line) parameter lists. This is
quite an ugly hack, but it is the recommended method of supporting these new
keywords (see the 2010-12-17 entry in the Perl::Tidy
[CHANGES](https://metacpan.org/source/SHANCOCK/Perl-Tidy-20120714/CHANGES)
file). __The resulting formatted code will leave the parameter lists untouched.__

`Perl::Tidy::Sweetened` attempts to support the syntax outlined in:

- Method::Signature::Simple
- MooseX::Method::Signatures
- MooseX::Declare

# SEE ALSO

[Perl::Tidy](http://search.cpan.org/perldoc?Perl::Tidy)

The idea and much of original code taken from Jonathan Swartz'
[blog](http://www.openswartz.com/2010/12/19/perltidy-and-method-happy-together/).

# BUGS

Please report any bugs or suggestions at
[http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Tidy-Sweetened](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Tidy-Sweetened)

# AUTHOR

Mark Grimes, <mgrimes@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Mark Grimes, <mgrimes@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
