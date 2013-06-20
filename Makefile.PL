use inc::Module::Install;

name     'Collectd-Plugins-OpenAFS';
all_from 'lib/Collectd/Plugins/OpenAFS.pm';
author   q{Fabien Wernli <wernli ate in2p3.fr>};
license  'perl';

test_requires 'Test::More';
test_requires 'Test::Collectd::Plugins';

install_share qw(share);

auto_install;

WriteAll;

