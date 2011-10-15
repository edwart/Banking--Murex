package Trace;
use strict;
use Carp;
use Data::Dumper;
use Env qw(TRACE TRACE_FORMAT TRACE_FILE);
use FileHandle;
use Time::HiRes qw/ gettimeofday /;

use vars qw($VERSION $AUTOLOAD);

require Exporter;
use POSIX qw/ strftime /;
$VERSION = "1.01";


sub AUTOLOAD
{
   shift if ref $_[0] eq 'Proc::Scheduler';
    $AUTOLOAD =~ /.*::(\w+)/ or croak "No such subroutine: $AUTOLOAD";
    output_message("Trace::$1", @_) if trace_this($1);

}
sub trace_this {
    my ($trace_what) = @_;
    return 0 unless defined $TRACE;
    return $TRACE =~ m/\b(all|$trace_what)\b/i;
}
sub trace_format {
    my ($trace_what) = @_;
    return 0 unless defined $TRACE_FORMAT;
    return $TRACE_FORMAT =~ m/\b($trace_what)\b/i;
}
sub output_message {
    my $type = shift @_;
    my $message = "";
    foreach my $m (@_) {
        my $type = ref $m;
        if ($type) {
            if ($type == "SCALAR") {
                $message .= $m;
            }
            elsif ($type == "REF") {
                $message .= Dumper($m);
            }
            else {
                $message .= Dumper(\$m);
            }
        }
        else {
                $message .= $m;
        }
    }
    $message =~ s/\s*$//;
    my ($seconds, $microseconds) = gettimeofday;
    my $timenow = strftime("%d/%m/%Y %H:%M:%S", 
		localtime($seconds)).sprintf(":%d",$microseconds/10000);
	my @message = ();
	push(@message, $timenow)	unless trace_format("notime");
	push(@message, $type)		unless trace_format("notype");
	push(@message, $message);
    my ($filename, $line_no) = (caller(1))[1,2];
    my ($subname ) = (caller(2))[3];
	push @message, "$filename($line_no) $subname";
	if ($TRACE_FILE and $TRACE_FILE ne "") {
		my $fh = new FileHandle ">> $TRACE_FILE";
		if ($fh) {
			$fh->print(join('|', @message), "\n");
			$fh->close;
		}
		else {
			carp "Can't open trace file $TRACE_FILE: $!\n";
			undef $TRACE_FILE;
			warn join('|', @message), "\n";
		}
	}
	else {
		warn join('|', @message), "\n";
	}
    
}
1;
__END__
