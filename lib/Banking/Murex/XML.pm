package Banking::Murex::XML;

use Moose::Role;
use English;
use Carp;
use XML::Simple;
use Sys::Hostname;
use Hash::Flatten qw/ flatten /;
use Data::Dumper;
use Trace;

sub parse_xml_file {
	my ( $self, $path, @tags) = @_;
    my $xml = XMLin($path);
    my $flatxml = flatten($xml);
    Trace::XML(Dumper($flatxml));
    if (@tags) {
        my @values = ();
        foreach my $tag (@tags) {
            push(@values, $flatxml->{$tag});
        }
        return @values;
    }
    else {
        return ($xml, $flatxml);
    }
}
1;
