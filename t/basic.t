use Test::Most;

use Perl::Tidy::Sweetend;

test_tidy( <<'RAW', <<'TIDIED', 'Normal sub usage' );
sub name1 {
}
sub name2 {
}
RAW
sub name1 {
}

sub name2 {
}
TIDIED

test_tidy( <<'RAW', <<'TIDIED', 'Simple method usage' );
method name1 {
}
sub name2 {
}
RAW
method name1 {
}

sub name2 {
}
TIDIED

test_tidy( <<'RAW', <<'TIDIED', 'Method with signature' );
method name1 (class: $that) {
}
method name2( :$arg1, :$arg2){
}
sub name3 {}
RAW
method name1 (class: $that) {
}

method name2 ( :$arg1, :$arg2) {
}
sub name3 { }
TIDIED

sub test_tidy {
    my ( $raw, $expected, $msg ) = @_;

    my @tidied;
    Perl::Tidy::Sweetend::perltidy(
        source      => \$raw,
        destination => \@tidied,
        perltidyrc  => undef,
        argv        => '-nsyn -ce -npro -l=60',
    );
    my $tidied = join '', @tidied;
    return eq_or_diff( $tidied, $expected, $msg );
}

done_testing();
