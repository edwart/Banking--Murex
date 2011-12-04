package Banking::Murex::Switches;

use Moose::Role;
use Trace;
use Data::Dumper;
use Hash::Flatten qw(:all);
use Getopt::Long qw/:config pass_through ignore_case auto_abbrev /; 

has verbose => ( is => 'ro',
                 isa => 'Bool',
                 default => 0 );
our %opts = ();
after BUILD => sub {
    my ($self) = @_;
    my $flatconfig = $self->flat_config;
    $flatconfig ||= {};

    foreach my $opt (keys %opts) {
        $self->mxenv($opts{mxenv}) if $opts{mxenv};
        $flatconfig->{$opt} = $opts{$opt};
    }
    Trace::CONFIG(Dumper($flatconfig, ref $flatconfig));
    my $config = unflatten($flatconfig);
    $self->config($config);

};
after BUILDARGS => sub {
    my ($class, %params) = @_;
    %opts = %params;
    my @opt_definitions = ();
    push(@opt_definitions, @{ $params{'extra_options'} }) if ($params{'extra_options'});
    Trace::PARAMS(Data::Dumper->Dump([\%params, \@opt_definitions], [qw/%params @opt_definitions/]));
    my $meta = Class::MOP::Class->initialize('Murex');
    my @attributes = $meta->get_all_attributes;
    foreach my $attribute (@attributes) {
        next unless $attribute->definition_context->{package} =~ m/^Murex/;
	next if $attribute->name =~ m/^(mxenv|configfile|config)$/;
        push(@opt_definitions, $attribute->name.'=s') if $attribute->has_writer or $attribute->has_write_method;
    }
#    local @ARGV = @ARGV;
    Trace::PARAMS(Data::Dumper->Dump([\@ARGV, \%params, \@opt_definitions], [qw/@ARGV %params @opt_definitions/]));
    GetOptions(\%opts, @opt_definitions );
    process_extra_commandline_options(\%opts);
    
    Trace::PARAMS(Data::Dumper->Dump([\%opts], [qw/%opts/]));

    return \%opts;
};
sub process_extra_commandline_options {
    my ($opts) = @_;
    my @remainingVals = ();
    local @ARGV = @ARGV;
    foreach my $extraop (@ARGV) {
        if ($extraop =~ m/^--([\S.]+)=([\S]+)\b/) {
            $opts->{$1} =  $2;
        } else {
                push @remainingVals, $extraop;
        }
    }
    @ARGV = @remainingVals;
}
sub usage {

}
no Moose;
1;
