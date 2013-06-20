use inc::Module::Install;

name     'Collectd-Plugins-OpenAFS';
all_from 'lib/Collectd/Plugins/OpenAFS.pm';
author   q{Fabien Wernli <wernli ate in2p3.fr>};
license  'perl';

build_requires 'Test::More';

install_share qw(share);

auto_install;

WriteAll;

