use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Banking::Murex',
    AUTHOR              => 'Tony Edwardson <tony@edwardson.co.uk>',
    VERSION_FROM        => 'lib/Banking/Murex.pm',
    ABSTRACT_FROM       => 'lib/Banking/Murex.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
	'Moose'	     => 0,
	'MooseX::Object::Pluggable' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Banking-Murex-*' },
);
