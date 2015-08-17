use Module::Build;

my $build = Module::Build->new(
    module_name   => 'Perl::Tidy::Sweetened',
    license       => 'perl',
    create_readme => 1,
    script_files  => [qw(script/perltidier)],
    requires      => {
        'perl'       => '5.010',    # Needed for RE{balanced}'s use of (?^)
        'Perl::Tidy' => 0,
        'Carp'       => 0,
    },
    build_requires => {
        'Test::Differences' => 0,
        'Test::More'        => 0.87,
        'Test::Most'        => 0,
    },
    configure_requires => { 'Module::Build' => '0.36', },
    meta_merge         => {
        resources => {
            bugtracker =>
              'http://github.com/mvgrimes/perl-tidy-sweetened/issues',
            repository => 'http://github.com/mvgrimes/perl-tidy-sweetened',
        }
    },
);

$build->create_build_script;

