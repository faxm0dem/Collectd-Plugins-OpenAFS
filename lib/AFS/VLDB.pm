package AFS::VLDB;

use Moose;

has 'vosbin' => (
	is => 'ro',
	isa => 'Str',
	default => 'vos',
);

has 'cellname' => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_cellname',
);

=head1 METHODS

=head2 listaddrs

Returns list of file servers

=cut

sub listaddrs {
	my $self = shift;
	my @result;
	my @cellname = ();
	if ($self -> has_cellname) {
		@cellname = ( '-cell', $self -> cellname );
	}
	open FH, '-|', $self -> vosbin, 'listaddrs', @cellname or die "$!";
	for (<FH>) {
		chomp;
		next if /^$/;
		next unless $_;
		push @result, { 'name-1' => $_ };
	}
	close FH;
	return @result;
}

1;

