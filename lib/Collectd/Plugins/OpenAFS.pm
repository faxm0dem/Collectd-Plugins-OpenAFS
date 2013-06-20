package Collectd::Plugins::OpenAFS;

use 5.006;
use strict;
use warnings;

=head1 NAME

Collectd::Plugins::OpenAFS - collect openafs metrics

=cut

our $VERSION = '0.1007';


=head1 DESCRIPTION

This plugin will use the openafs command line helpers to query statistics.
Currently it ships with CLI wrapper classes L<AFS::VOS> and L<AFS::VLDB>, as the XS modules that are available on CPAN are troublesome to build, especially using recent versions of openafs. This will happily change in the future, if the latter product is improving.

=head1 SYNOPSIS

This is the base class. Don't use it.

=head1 SEE ALSO

L<Collecdt::Plugins::OpenAFS::VOS>

=head1 AUTHOR

Fabien Wernli, C<< <wernli ate in2p3.fr> >>

=head1 BUGS

Please report any bugs to github at L<https://github.com/faxm0dem/Collectd-Plugins-OpenAFS/issues>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Collectd::Plugins::OpenAFS


You can also look for information at:

=over 4

=item * GitHub

L<https://github.com/faxm0dem/Collectd-Plugins-OpenAFS/>

=item * Search CPAN

L<http://search.cpan.org/dist/Collectd-Plugins-OpenAFS/>

=back


=head1 ACKNOWLEDGEMENTS

SYN

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Fabien Wernli.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Collectd::Plugins::OpenAFS
