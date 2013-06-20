package Collectd::Plugins::OpenAFS::VOS;

use strict;
use warnings;

use Collectd qw( :all );
use AFS::VOS;
use AFS::VLDB;

my $interval = $interval_g;
my $hostname = $hostname_g;
my $last_ts = 0;
my @fileserver_from_config;
my $vosbin = "/usr/afsws/etc/vos";
my $plugin_name = __PACKAGE__;
my $cellname;
$plugin_name =~ s/Collectd::Plugins:://;
$plugin_name =~ s/::/_/;
$plugin_name = lc $plugin_name;

=head1 NAME

Collectd::Plugins::OpenAFS::VOS - Collectd plugin for OpenAFS

=head1 DESCRIPTION

This probe provides file server statistics for volumes

=head1 SYNOPSIS

To be used with L<collectd-perl>.

=head1 CONFIGURATION

The configuration is best explained in an example:

 LoadPlugin perl
 
 <Plugin perl>
   BaseName "Collectd::Plugins"
   LoadPlugin "OpenAFS::VOS"
   <Plugin "openafs_vos">
     VosBin "/usr/bin/vos"
     Interval 600
     SetHost "openafs.mydomain.mytld"
     CellNAme "mydomain.mytld"
   </Plugin>
 </Plugin>

=cut

plugin_register(TYPE_CONFIG, $plugin_name, 'my_config');
plugin_register(TYPE_READ, $plugin_name, 'my_get');
plugin_register(TYPE_INIT, $plugin_name, 'my_init');

=head1 CALLBACKS

=head2 my_init

Used as TYPE_INIT by L<collectd-perl>.
Currently does nothing

=cut

sub my_init {
	1;
}

=head2 my_log

Convenience alias to L<collectd-perl/plugin_log> that adds the plugin name.

=cut

sub my_log {
	plugin_log shift @_, join " ", "$plugin_name", @_;
}

=head2 my_config

Used as TYPE_CONFIG by L<collectd-perl>.
Supported configuration options:

=over

=item * Interval (Scalar)
 
=item * FileServer (List): fileservers to query. If empty, the plugin will try to fill in the list of all fileservers of cell L<CellName> or the system's ThisCell.

=item * VosBin (Scalar): path to B<vos> executable. defaults to C</usr/afsws/etc/vos> (yes, we're old school)

=item * SetHost (Scalar): host part to set for collectd values

=item * Host: alias to L<SetHost>

=item * CellName (Scalar): specify cell name (only used if L<FileServer> is unspecified). If left empty, the fileserver list will be fetched for the system's configured ThisCell.

=back

=cut

sub my_config {
	for my $child (@{$_[0] -> {children}}) {
		if ($child -> {key} eq "Interval") {
			$interval = $child -> {values} -> [0];
			my_log(LOG_DEBUG, "Registered option Interval = $interval");
		} elsif ($child -> {key} eq "FileServer") {
			@fileserver_from_config = @{$child -> {values}};
			my_log(LOG_DEBUG, "Registered option FileServer = ".join(",",@fileserver_from_config));
		} elsif ($child -> {key} eq "VosBin") {
			$vosbin = $child -> {values} -> [0];
			my_log(LOG_DEBUG, "Registered option VosBin = $vosbin");
		} elsif ($child -> {key} eq "CellName") {
			$cellname = $child -> {values} -> [0];
			my_log(LOG_DEBUG, "Registered option CellName = $cellname");
		} elsif ($child -> {key} eq "Host" || $child -> {key} eq "SetHost") {
			$hostname = $child -> {values} -> [0];
			my_log(LOG_DEBUG, "Registered option Host = $hostname");
		} else {
			my_log(LOG_WARNING, "Unrecognized plugin option ".$child->{key});
		}
	}
}

=head2 my_get

Used as TYPE_READ by L<collectd-perl>.
Gets list of all fileservers (unless specified in config), and gets list of all volumes for each, and returns the following metrics (will be configurable in the future):

=over

=item * status

=item * maxquota

=item * dayUse

=back

=cut

sub my_get {
	my $ts = time;
	return 1 if ($ts < $interval + $last_ts);
	my $vos = AFS::VOS -> new(vosbin => $vosbin);
	my @fileserver;
	if (@fileserver_from_config) {
		@fileserver = @fileserver_from_config;
	} else {
		my %cellname = $cellname ? ("cellname" => $cellname) : ();
		my $vldb = AFS::VLDB -> new(vosbin => $vosbin, %cellname);
		@fileserver = map { values %{$_} } $vldb -> listaddrs();
	}
	for my $fs (@fileserver) {
		my $listvol = $vos -> listvol($fs);
		for (values %$listvol) {
			while (my ($vol,$info) = each %$_) {
				next if $vol =~ /^\ /;
				
				for my $type (qw/size maxquota/) {
					$info -> {$type} *= 1024 if defined $info -> {$type};
				}
				for my $type (qw/status size dayUse maxquota/) {
					plugin_dispatch_values({
						plugin => $plugin_name,
						plugin_instance => $info -> {server},
						type => 'listvol_'.$type,
						type_instance => $info -> {name},
						values => [$info -> {$type}],
						interval => $interval,
						host => $hostname,
					}) if defined $info -> {$type};
				}
			}
		}
	}
	$last_ts = $ts;
  return 1;
}

1;

