use Test::More tests => 5;
use Data::Dumper;

BEGIN {

use Banking::Murex;
ok(Banking::Murex->new, 'Instantiate');
}

BEGIN {
use Banking::Murex;
my $mx = Banking::Murex->new;
isa_ok($mx, 'Banking::Murex');
}


BEGIN {
use Banking::Murex;
my $mx = Banking::Murex->new(MxEnv => "Fred");
is($mx->MxEnv(), "Fred", "MxEnv passed");
}

BEGIN {
use Banking::Murex;
$ENV{MXENV} = "Bloggs";
my $mx = Banking::Murex->new();
is($mx->MxEnv(), "Bloggs", "MxEnv by env var");
}

BEGIN {
use Banking::Murex;
undef($ENV{MXENV});
my $mx = Banking::Murex->new();
my $user = scalar getpwuid $<;
is($mx->MxEnv(), $user, "MxEnv by current user");
warn Dumper $mx->Config;
}

diag( "Testing Banking::Murex $Banking::Murex::VERSION" );
