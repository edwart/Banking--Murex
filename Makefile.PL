use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Banking::Murex',
    AUTHOR              => 'Tony Edwardson <tony@edwardson.co.uk>',
    VERSION_FROM        => 'lib/Banking/Murex.pm',
    ABSTRACT       	=> 'a Perl Module to work with Murex',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
	'Moose'	     => 0,
	'XML::Simple'	     => 0,
	'Log::Log4perl'	     => 0,
	'Hash::Flatten'	     => 0,
	'Template'	     => 0,
#	'MooseX::Object::Pluggable' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Banking-Murex-*' },
);
