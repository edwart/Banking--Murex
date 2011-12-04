package Banking::Murex::Log;

use Moose::Role;
use English;
use Data::Dumper;
use Template;
use FileHandle;
use Log::Log4perl;
with 'MooseX::Log::Log4perl';

has logconfig => ( is => 'rw',
                   isa => 'Str',
				   predicate => 'has_logconfig',
                   builder => '_get_logconfig',
                   lazy => 1,
                   required => 0 );

after BUILD => sub {
    my $self = shift;
    unless ($self->has_logconfig()) {
        $self->logconfig( join('/', $self->configdir, $self->mxenv. '_log4perl.conf') );
    }
    unless (-f $self->logconfig()) {
        $self->_create_logconfig($self->logconfig());
    }
    umask 0047;
    Log::Log4perl::init($self->logconfig) if -f $self->logconfig;
};
sub _get_logconfig {
    my $self = shift;
    return join('/', $self->configdir, uc($self->mxenv). '_log4perl.conf');
}
sub _create_logconfig {
    my ($self, $configfile) = @_;
	return unless $self->does('process_template');
    my $fh = FileHandle->new("> $configfile", );
    my $cfg = $self->edw();
    my $output;
    $self->process_template('log4perl.conf', $cfg, \$output);
    $fh->print($output);
    $fh->close;

}
1;
__END__

