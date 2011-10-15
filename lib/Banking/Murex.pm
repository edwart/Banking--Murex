package Banking::Murex;

our $VERSION = '0.0.2';
use Moose;
use Try::Tiny;
use Data::Dumper;
use Getopt::Long qw/:config pass_through ignore_case auto_abbrev /; 
my %opts = ();

GetOptions(\%opts, 'mxenv=s',
           'configfile=s' );
use vars qw/ %imports %roles /;
with 'Banking::Murex::Config';
with 'Banking::Murex::Switches';
with 'Banking::Murex::Template';
with 'Banking::Murex::XML';
with 'Banking::Murex::Log';

has mxenv   => ( is => 'rw',
                 isa => 'Str',
                 lazy => 1,
                 predicate => 'has_mxenv',
                 builder => '_get_mxenv',
                 required => 1 );
%roles = ();
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
    } catch {
#       print "no Banking::Murex::$role $_ $@\n";
    } finally {
        $roles{$role} = @_ ? 0 : 1;
    };
}

sub BUILDARGS {
    my $class = shift;
    my %params = ( %opts, %imports, @_ );
    return \%params;
}

sub BUILD { 
}
sub import {
    my $class = shift;
    if (scalar(@_) % 2 == 0) {
        %imports = @_;
    }
}
sub _get_mxenv {
    my $self = shift;
    return $self->mxenv if $self->has_mxenv;
    return uc($ENV{MXENV}) if $ENV{MXENV};
}

no Moose;

__PACKAGE__->meta->make_immutable; # Speed up class by preventing runtime changes to class;
1;
