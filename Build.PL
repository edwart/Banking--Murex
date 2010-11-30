use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Banking::Murex',
    license             => 'perl',
    dist_author         => 'Tony Edwardson <tony@edwardson.co.uk>',
    dist_version_from   => 'lib/Banking/Murex.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Banking-Murex-*' ],
);

$builder->create_build_script();
