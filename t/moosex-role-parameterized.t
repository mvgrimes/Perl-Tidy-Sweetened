use lib 't/lib';
use TidierTests;
TidierTests::do_tests(\*DATA);

__DATA__
==== Normal sub usage ===================================================
role {                                | role {
    method _test => sub { };          |     method _test => sub { };
};                                    | };
