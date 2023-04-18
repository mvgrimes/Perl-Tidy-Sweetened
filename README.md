# NAME

Perl::Tidy::Sweetened - Tweaks to Perl::Tidy to support some syntactic sugar

# VERSION

version 1.19

# STATUS

<div>
    <a href="https://travis-ci.org/mvgrimes/Perl-Tidy-Sweetened"><img src="https://travis-ci.org/mvgrimes/Perl-Tidy-Sweetened.svg?branch=master" alt="Build Status"></a>
    <a href="https://metacpan.org/pod/Perl::Tidy::Sweetened"><img alt="CPAN version" src="https://badge.fury.io/pl/Perl-Tidy-Sweetened.svg" /></a>
</div>

# DESCRIPTION

There are a number of modules on CPAN that allow users to write their classes
with a more "modern" syntax. These tools eliminate the need to shift off
`$self`, can support type checking and offer other improvements.
Unfortunately, they can break the support tools that the Perl community has
come to rely on. This module attempts to work around those issues.

The module uses
[Perl::Tidy](https://metacpan.org/pod/Perl%3A%3ATidy)'s `prefilter` and `postfilter` hooks to support `method` and
`func` keywords, including the (possibly multi-line) parameter lists. This is
quite an ugly hack, but it is the recommended method of supporting these new
keywords (see the 2010-12-17 entry in the Perl::Tidy
[CHANGES](https://metacpan.org/source/SHANCOCK/Perl-Tidy-20120714/CHANGES)
file). **The resulting formatted code will leave the parameter lists untouched.**

`Perl::Tidy::Sweetened` attempts to support the syntax outlined in the
following modules, but most of the new syntax styles should work:

- p5-mop
- Method::Signatures::Simple
- MooseX::Method::Signatures
- MooseX::Declare
- Moops
- perl 5.20 signatures
- Kavorka

# THANKS

The idea and much of original code taken from Jonathan Swartz'
[blog](http://www.openswartz.com/2010/12/19/perltidy-and-method-happy-together/).

# SEE ALSO

[Perl::Tidy](https://metacpan.org/pod/Perl%3A%3ATidy)

# AUTHOR

Mark Grimes <mgrimes@cpan.org>

# SOURCE

Source repository is at [https://github.com/mvgrimes/Perl-Tidy-Sweetened](https://github.com/mvgrimes/Perl-Tidy-Sweetened).

# BUGS

Please report any bugs or feature requests on the bugtracker website [https://github.com/mvgrimes/Perl-Tidy-Sweetened/issues](https://github.com/mvgrimes/Perl-Tidy-Sweetened/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# COPYRIGHT AND LICENSE

This software is copyright (c) 2023 by Mark Grimes <mgrimes@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
