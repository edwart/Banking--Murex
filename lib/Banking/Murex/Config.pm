package Banking::Murex::Config;

use Moose::Role;
use English;
use Env qw/ MXENV /;

has ConfigPlugin => ( is      => 'rw',
                      isa     => 'Str',
                      reader  => '_get_ConfigPlugin',
                      default => 'ConfigFromXML',
                    );
has Config => ( is      => 'rw',
                isa     => 'HashRef',
                lazy    => 1,
                builder => 'get_config',
          );

has MxEnv => ( is       => 'ro',
               isa      => 'Str',
               required => 1,
               builder  => '_workout_environment',
       );

sub _workout_environment {
    $MXENV ||= scalar getpwuid $EUID;
    return $MXENV;
}
        

after BUILD => sub {
    my $self = shift;
    $self->load_plugins( $self->_get_ConfigPlugin );
};

sub get_value {


}
sub set_value {

}
1;
