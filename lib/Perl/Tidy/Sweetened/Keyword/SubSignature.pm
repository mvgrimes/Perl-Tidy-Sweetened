package Perl::Tidy::Sweetened::Keyword::SubSignature;

use strict;
use warnings;

# Regex to match balanced parans. Reproduced from Regexp::Common to avoid
# adding a non-core dependency.
#   $RE{balanced}{-parens=>'()'};
# The (?-1) construct requires 5.010
our $Clause = '(?:((?:\((?:(?>[^\(\)]+)|(?-1))*\))))';

sub new {
    my ( $class, %args ) = @_;
    die 'keyword not specified' if not exists $args{keyword};
    die 'marker not specified'  if not exists $args{marker};
    return bless {%args}, $class;
}

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

sub keyword { return $_[0]->{keyword} }
sub marker  { return $_[0]->{marker} }

sub emit_sub {
    my ( $self, $subname, $signature, $prelude ) = @_;
    my $esignature = escape_params($signature);
    $esignature = '' if not defined $esignature;
    return sprintf 'sub %s %s #__%s %s',
      $subname,
      $prelude,
      $self->marker,
      $esignature;
}

sub emit_keyword {
    my ( $self, $subname, $signature, $padding, $prelude ) = @_;
    my $esignature = unescape_params($signature);
    $esignature = '' if not defined $esignature;
    return sprintf '%s %s%s%s%s',
      $self->keyword,
      $subname,
      $esignature,
      $padding,
      $prelude;
}

sub prefilter {
    my ( $self, $code ) = @_;
    my $keyword = $self->keyword;
    my $marker  = $self->marker;
    $code =~ s{
        ^\s*\K            # okay to have leading whitespace (preserve)
        $keyword \s+        # the "func" keyword
        (\w+)  \s*        # the function name ($1)
        (?:$Clause)?      # optional parameter list (multi-line ok) ($2 in Clause)
        (.*?)             # anything else (ie, comments) ($3)
        $
    }{
        $self->emit_sub( $1, $2, $3 )
    }gxem;
    return $code;
}

sub postfilter {
    my ( $self, $code ) = @_;
    my $keyword = $self->keyword;
    my $marker  = $self->marker;

    # Convert back to method
    $code =~ s{
        ^\s*\K            # preserve leading whitespace
        sub \s+           # method was convert to sub
        (\w+)\b           # the method name and a word break ($1)
        (.*?)[ ]*         # anything originally following the declaration ($2)
        \#__$marker        # out magic token
        (\s $Clause)?     # option parameter list ($3 & $4 in Clause)
        [ ]*              # trailing spaces
    }{
        $self->emit_keyword( $1, $3, '', $2 );
    }gmex;

    # Check to see if tidy turned it into "sub name\n{ #..."
    $code =~ s{
        ^\s*\K            # preserve leading whitespace
        sub \s+           # method was converted to sub
        (\w+)\n           # the method name and a newline ($1)
        \s* \{(.*?) [ ]*  # opening brace on newline followed orig comments ($2)
        \#__$marker        # our magic token
        (\s $Clause)?     # optional parameter list ($3 & $4 in Clause)
        [ ]*              # trailing spaces
    }{
        $self->emit_keyword( $1, $3, ' \{', $2 );
    }gmex;
    return $code;
}

1;
