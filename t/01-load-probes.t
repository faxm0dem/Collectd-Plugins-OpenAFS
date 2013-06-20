#!perl

use Test::More;
use Test::Collectd::Plugins;

BEGIN {
	eval { require Module::Pluggable }
		|| plan skip_all => 'Test needs Module::Pluggable';
	my @found = Module::Pluggable::Object->new(
		require => 1,
		inner => 0,
		search_path=>'Collectd::Plugins::OpenAFS',
	)->plugins;
	my $nfound = scalar @found;
	plan tests => $nfound;
	diag("Testing $nfound Collectd::Plugins::OpenAFS probes");
	for (@found) {
		load_ok($_,"load_ok $_");
	}
}

