#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Collectd::Plugins::OpenAFS' ) || print "Bail out!\n";
}

diag( "Testing Collectd::Plugins::OpenAFS $Collectd::Plugins::OpenAFS::VERSION, Perl $], $^X" );
