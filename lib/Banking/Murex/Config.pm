package Banking::Murex::Config;

use Moose::Role;


sub get_config_from_file {
	my ($class, $file) = @_;

	my $options_hashref = Some::ConfigFile::Loader->load($file);

	return $options_hashref;
}
`
