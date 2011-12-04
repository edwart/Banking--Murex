package Banking::Murex::Config;

use Moose::Role;
use File::Basename;
use FindBin qw/ $Bin /;
use English;
use Data::Dumper;
use Hash::Flatten qw/ flatten /;
use Template;
use Trace;
use XML::Simple;
use Hash::Merge qw/ merge /;
Hash::Merge::set_behavior( 'LEFT_PRECEDENT' );

has mxenv	=> ( is => 'rw',
                 isa => 'Str',
                 lazy => 1,
                 predicate => 'has_mxenv',
                 builder => '_get_mxenv',
                 required => 0 );

has configdir => ( is => 'rw',
                   isa => 'Str',
                   default => dirname( $Bin ). '/config',
                   required => 0 );

has configfile => ( is => 'rw',
                   isa => 'Str',
                   lazy => 1,
                   builder => '_get_configfile',
                   required => 0 );

has config => ( is => 'rw',
                isa => 'HashRef',
                required => 0 );
                 
after BUILD => sub {
    my $self = shift;
    my $config = $self->config;
    $config ||= {};
    $self->configfile( 'MurexEnv_'. uc $self->mxenv(). '.xml' )
                    unless $self->configfile;
    my $merged = $self->__include_config($config,$self->configfile);
    Trace::MERGED(Data::Dumper->Dump([$merged], [qw/$merged/]));
        
    $self->config($merged);

    return $self->config;
};
sub _get_mxenv {
    my $self = shift;
	return $self->mxenv if $self->has_mxenv;
	return $ENV{MXENV} if $ENV{MXENV};
	return 'unset';
}
sub flat_config {
    my $self = shift;
    my $config = $self->config;
   $config ||= {};
    return flatten($config);
}
sub _get_configfile {
    my $self = shift;
    my $mxenv = uc $self->mxenv;
    return "MurexEnv_${mxenv}.xml";

}
sub apptree {
    my $self = shift;
    return $self->get_from_edw('Murex.Directory.Application');
}
sub get_from_config {
    my ($self, $what) = @_;
    my $cfg = $self->config();
    my $flatcfg = $self->flat_config();
    return $cfg->{$what} if exists $cfg->{$what};
    return $flatcfg->{$what} if exists $flatcfg->{$what};
    if (exists $flatcfg->{"$what:0"}) {
        my @values = ();
        my $n = 0;
        while (exists $flatcfg->{"$what:$n"}) {
            push(@values, $flatcfg->{"$what:$n"});
            $n++;
        }
        return \@values;
    }
    return undef;
}
sub __include_config {
    my ($self, $existing, $config) = @_;
    Trace::CONFIG(Data::Dumper->Dump([$existing, $config], [qw/$existing $config/]));
    my $path = $config =~ m!^/! ? $config
                                : join('/', $self->configdir, $config);
	return {} unless -f $path;
    my $new = XMLin($path);
    my $merged = merge( $existing, $new );
    Trace::CONFIG(Data::Dumper->Dump([$new, $merged], [qw/$new $merged/]));
    if (defined $new->{Include}) {
        if (ref $new->{Include} eq 'ARRAY') {
            foreach my $include (@{ $new->{Include} }) {
                $merged = $self->__include_config($merged,$include);
            }
        }
        else {
            $merged = $self->__include_config($merged,$new->{Include});
        }
    }
    Trace::CONFIG(Data::Dumper->Dump([$merged], [qw/$merged/]));
    return $merged;
}

1;
__END__

