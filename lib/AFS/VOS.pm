package AFS::VOS;

use Moose;

has 'vosbin' => (
	is => 'ro',
	isa => 'Str',
	default => 'vos',
);

=head1 METHODS

=head2 listvol

Attrs: fileserver (Str)

Returns data structure with volume statistics

=cut

sub listvol {
	my ($self,$fileserver) = @_;
	my %result;
	open FH, '-|', $self -> vosbin, 'listvol', $fileserver, '-long' or die "$!";
	my %current; # my ($server, $part, $name, $size, $dayUse, $maxquota);
	while (<FH>) {
		chomp;
		if (/^Total number of volumes on server (.+) partition (.+):/) {
			%current = ();
			$current{server} = $1;
			$current{part} = $2;
			next;
		}
		if (/^$/) {
			next unless defined $current{part};
			next unless defined $current{name};
			my $part = $current{part};
			my $name = $current{name};
			$result{$part} = {} unless exists $result{$part};
			for (qw/name part size dayUse server maxquota/) {
				$result{$part} -> {$name} -> {$_} = $current{$_} if (defined $current{$_});
			}
			next;
		}
		if (/^Total volumes onLine (\d+) ; Total volumes offLine (\d+) ; Total busy (\d+)/) {
			if (defined $current{part}) {
				my $part = $current{part};
				$result{$part} = {} unless exists $result{$part};
				$result{$part} -> {' totalOK'} = $1;
				$result{$part} -> {' totalNotOK'} = $2;
				$result{$part} -> {' totalBusy'} = $3;
			}
			%current = ();
			next;
		}
		if (/^\S/) {
			if (defined $current{server} && defined $current{part}) {
				my ($name,undef,undef,$size) = split /\s+/, $_ or die;
				$current{name} = $name;
				$current{size} = $size;
			} else {
				die "server or partition undefined";
			}
			next;
		}
		if (/^\s/) {
			if (/MaxQuota\s+(\d+)/) {
				$current{maxquota} = $1;
			} elsif (/(\d+)\s+accesses/) {
				$current{dayUse} = $1;
			}
			next;
		}
	}
	close FH;
	return \%result;
}

1;

