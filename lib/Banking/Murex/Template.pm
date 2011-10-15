package Banking::Murex::Template;

use Moose::Role;

use FindBin qw/ $Bin /;
use File::Basename qw/ dirname /;
use Data::Dumper;
use Template;
use Template::Parser;
use Template::Constants qw( :debug );
use Hash::Flatten qw/ flatten /;
use FileHandle;

has 'tt2' => ( is => 'ro', 
			   isa => "Template", 
			   builder => '_template_object',
            );

sub _template_object {
    return Template->new(ABSOLUTE => 1,
			DEBUG => DEBUG_UNDEF);
#    return Template->new(INCLUDE_PATH => dirname($Bin)."/templates",
#                         DEBUG => DEBUG_UNDEF);
}
sub process_template {
	my ($self, $template, $data, $output) = @_;
    my $flat_data = flatten $data;
=pod
    my @tags = $self->get_template_tags($template);
    my %values = ();
    foreach my $tag (@tags) {
        unless (exists($flat_data->{$tag})) {
            $self->log->error("Tag [% $tag %] in $template does not exist in config");
            $values{$tag} = "Undefined";
        }
        else {
            $values{$tag} = $flat_data->{$tag};
        }
    }
    $self->log->debug(Dumper(%values));
=cut

	my $tt2 = $self->tt2();
	$tt2->process($template, $data, ref $output ? $output : \$output) or die $tt2->error;
    return $output;
}
sub get_template_tags {
    my ($self, $template) = @_; 
    my $path = $template;
    my $fh = FileHandle->new( "< $path" ) or die "Whoops: can't open template  $path: $!";
#    my $path = dirname($Bin)."/templates/$template";
#    my $fh = FileHandle->new( "< $path" ) or die "Whoops: can't open template  $path: $!";
    my @lines = <$fh>;
    $fh->close;
    my $text = join("\n", @lines);
    my $p = Template::Parser->new();
#    my $p = Template::Parser->new(INCLUDE_PATH => dirname($Bin)."/templates");
    my $t = $p->parse($text);
    my @tagcode = $t->{BLOCK} =~ m/stash->get\(([^)]+)\)/g;

    my %tags = ();
    our $tags;
    my @tags = ();
    foreach my $tagarray (@tagcode) {
        eval "\$tags = $tagarray;";
        my @tagbits = ();
        for (my $i=0; $i<scalar(@{ $tags }); $i+=2) {
            push(@tagbits, $tags->[$i]);
        }
        $tags{join('.', @tagbits)} = 1;
    }
    return keys %tags;
}

1;
