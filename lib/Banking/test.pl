#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use FindBin qw/ $Bin /;
use File::Basename qw/ dirname /;

use lib dirname $Bin;

use Banking::Murex;
my $mx = Banking::Murex->new(mxenv => "fred");
my $mxenv= $mx->mxenv;
print Data::Dumper->Dump([ $mxenv], [qw/$mxenv/]);
my $cfg = $mx->config;
print Data::Dumper->Dump([ $cfg], [qw/$cfg/]);
