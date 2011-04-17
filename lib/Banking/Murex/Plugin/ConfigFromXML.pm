package Banking::Murex::Plugin::ConfigFromXML;

use Moose::Role;
use MooseX::Types::Path::Class;
use Carp qw/ croak /;
use FindBin qw/ $Bin /;
use File::Basename qw/ dirname /;
use English;
use Sys::Hostname;
use XML::Simple;

has ConfigDir => ( is 	=> 'ro',
				   isa 	=> 'Path::Class::Dir'
				   required => 1,
				   default => dirname( $Bin ). "/config";
				   coerce => 1,
				    );

has ConfigFile => ( is 	=> 'rw',
				   isa 	=> 'Path::Class::File'
				   required => 0,
				    );

sub get_config {
	my $self = shift;
	my $params = shift;

	my $configfile = join('/', $self->ConfigDir	, 'MurexEnv_'.$self->MxEnv().'.xml');
	croak("Config file $configfile does not exist") unless -f $configfile;
	my $config = XMLin($configfile);
	return $config;
}
1;
