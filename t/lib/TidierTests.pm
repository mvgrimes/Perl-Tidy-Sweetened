package TidierTests;

use Perl::Tidy::Sweetened;
use Test::Most;

sub do_tests {
    my ( $fh, @args ) = @_;

    my ( $message, @test, $todo );
    while ( my $line = <$fh> ) {
        if ( $line =~ /^={2,} \s* (TODO:?)? \s* (.*) \s =+ \s* $/x ) {
            $todo    = defined $1;
            $message = $2;
        } elsif ( $line =~ /^\s*$/ ) {
            test_tidy( \@test, $message, $todo, @args );
            undef $message;
            @test = ();
        } elsif ( $line =~ /[|]/ ) {
            push @test, $line;
        } else {
            die "Poorly formatted test at:\n$line";
        }
    }

    # Test the last one
    test_tidy( \@test, $message, $todo, @args ) if $message;
    done_testing();
}

sub test_tidy {
    my ( $code, $msg, $todo, @args ) = @_;
    my ( @raw, @expected );

    for my $line (@$code) {
        my ( $raw_line, $expected_line ) = split /\s*[|] ?/, $line;
        push @raw, $raw_line unless $raw_line eq "~";
        $expected_line = '' unless defined $expected_line;
        push @expected, $expected_line unless $expected_line eq "~";
    }

    my $raw      = join "\n", @raw;
    my $expected = join '',   @expected;

    run_test( $raw, $expected, $msg, $todo, @args );
}

sub run_test {
    my ( $raw, $expected, $msg, $todo, @args ) = @_;

    unlink 'perltidy.ERR' if -e 'perltidy.ERR';

    my @tidied;
    ## warn "# -nsyn -ce -npro -l=60 " . join( ' ', @args ), "\n";
    Perl::Tidy::Sweetened::perltidy(
        source      => \$raw,
        destination => \@tidied,
        perltidyrc  => undef,
        argv        => '-nsyn -ce -npro -l=60 ' . join( ' ', @args ),
    );
    my $tidied = join '', @tidied;

    if ($todo) {

      TODO: {
            # Works with Test::More prior to 1.301001_?
            local $TidierTests::TODO = 'Not implmented';

            # Works with Test::More after 1.301001_021
            local $TODO = 'Not implmented';

            return check_test( $tidied, $expected, $msg );
        }

    } else {
        return check_test( $tidied, $expected, $msg );
    }
}

sub check_test {
    my ( $tidied, $expected, $msg ) = @_;

    my $ok_log = ok( !-e 'perltidy.ERR', "$msg: no errors" );
    my $ok_tidy = eq_or_diff( $tidied, $expected, "$msg: matches" );

    return $ok_log && $ok_tidy;
}

1;
