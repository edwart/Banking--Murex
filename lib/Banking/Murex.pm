package Banking::Murex;

our $VERSION = '0.0.2';
use Moose;
use Exporter::Declare;
use Try::Tiny;
use Data::Dumper;
our %roles = (Config	=> 1,
			  Switches	=> 1,
			  Template	=> 1,
			  XML 		=> 1,
			  Log		=> 1 );
			
default_exports qw/ /;
import_options qw/ 	/;
import_arguments qw/ /;

with 'Banking::Murex::Config';
with 'Banking::Murex::Template';
with 'Banking::Murex::XML';
with 'Banking::Murex::Log';
with 'Banking::Murex::Switches';

my @optional_roles = (qw/Email
						 RPC
						 Database
						 Trace
						 Process
						 Monitor
						 MemCached
						 ProcessingScript/);
# Optional Roles - Load if installed
my @options = map { "With$_" } @optional_roles;
import_options @options;
sub after_import {
	my $class = shift;
	my ( $importer, $specs ) = @_;
		
	foreach my $opt_role (@optional_roles) {
		if ($specs->config->{"With$opt_role"}) {
			$roles{$opt_role} = 1;
			try {
				with "Banking::Murex::$opt_role";
			} catch {
				$roles{$opt_role} = 0;
			} finally {
				print qq!with "Banking::Murex::$opt_role"! if $roles{$opt_role};
			};
		}
		else {
			$roles{$opt_role} = 0;
		}
	}
	print Dumper \%roles;
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
