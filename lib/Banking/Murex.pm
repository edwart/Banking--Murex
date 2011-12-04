package Banking::Murex;

our $VERSION = '0.0.2';
use Moose;
use Moose::Exporter;
use Try::Tiny;
use Carp;
use Data::Dumper;

with 'Banking::Murex::Config';
with 'Banking::Murex::Template';
with 'Banking::Murex::XML';
with 'Banking::Murex::Log';
with 'Banking::Murex::Switches';

# Optional Roles - Load if installed
foreach my $role (qw/Banking::Murex::Email
                     Banking::Murex::RPC
                     Banking::Murex::Database
                     Banking::Murex::Trace
                     Banking::Murex::Process
                     Banking::Murex::Monitor
                     Banking::Murex::MemCached
                     Banking::Murex::ProcessingScript/) {
    try {
        with "Banking::Murex::$role";
    };
}

sub BUILDARGS {
	my $self = shift;
    my %params = ( @_ );
    return \%params;
}

sub BUILD { } 

no Moose;

__PACKAGE__->meta->make_immutable; # Speed up class by preventing runtime changes to class;
1;
__END__
=pod

=head1 NAME

Banking::Murex

=head1 SYNOPSIS

use Murex;

my $mx = Murex->new();

=head1 DESCRIPTION

=head1 OPTIONS


=cut
