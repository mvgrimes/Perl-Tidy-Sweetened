#!/usr/bin/env perl

# Test that the syntax of our POD documentation is valid
use strict;

BEGIN {
    $|  = 1;
    $^W = 1;
}

my @MODULES = ( 'Test::Spelling 0.20', );

# Don't run tests during end-user installs
use Test::More;
# plan( skip_all => 'Author tests not required for installation' )
#   unless ( $ENV{RELEASE_TESTING} or $ENV{AUTOMATED_TESTING} );

# Load the testing modules
foreach my $MODULE (@MODULES) {
    eval "use $MODULE";
    if ($@) {
        $ENV{RELEASE_TESTING}
          ? die("Failed to load required release-testing module $MODULE")
          : plan( skip_all => "$MODULE not available for testing" );
    }
}

all_pod_files_spelling_ok();

1;
