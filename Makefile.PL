# -*- perl -*-

use 5.008;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use DBI::DBD;

my %opts = (
    MIN_PERL_VERSION => '5.008',
    META_MERGE       => {
                    resources => {
# not public # repository => 'https://svn.perl.org/modules/SQL-Statement/trunk/',
                                  MailingList => 'mailto:dbi-dev@perl.org',
                                  license     => 'http://dev.perl.org/licenses/',
                                 },
		    recommends => {
		       'NDBM_File' => 0,
		       'ODBM_File' => 0,
		       'GDBM_File' => 0,
		    },
                  },
    NAME          => 'Bundle::DBD::DBM',
    VERSION_FROM  => 'lib/Bundle/DBD/DBM.pm',
    ABSTRACT_FROM => 'lib/Bundle/DBD/DBM.pm',
    dist          => {
              'SUFFIX'       => ".gz",
              'DIST_DEFAULT' => 'manifest tardist',
              'COMPRESS'     => "gzip -9vf"
            },
    PREREQ_PM => {
                   'SQL::Statement'      => '1.33',
		   # means: DBI >= 1.616
		   'DBI::DBD::SqlEngine' => '0.03',
		   'DBD::File'           => '0.40',
		   'DBD::DBM'            => '0.06',
		   'MLDBM'               => 0,
		   'MLDBM::Serializer::YAML' => '0.10',
		   'MLDBM::Serializer::JSON' => '0.001',
		   'FreezeThaw' => '0.5001',
		   'DB_File' => '1.821',
		   'BerkeleyDB' => '0.43',
		   'BerkeleyDB::Hash' => 0, # this module doesn't have a version
                 },
    LICENSE        => 'perl',
    BUILD_REQUIRES => {
        'Test::Simple' => '0.90',
                      },
    AUTHOR => 'Jens Rehsack <rehsack@cpan.org>',
    test   => { TESTS => 't/*.t xt/*.t' },
              );

WriteMakefile1(
    dbd_edit_mm_attribs(\%opts, {
	create_pp_tests => 1,
	create_nano_tests => 1,
	create_gap_tests => 1,
    })
);

sub WriteMakefile1
{    #Written by Alexandr Ciornii, version 0.21. Added by eumm-upgrade.
    my %params       = @_;
    my $eumm_version = $ExtUtils::MakeMaker::VERSION;
    $eumm_version = eval $eumm_version;
    die "EXTRA_META is deprecated" if ( exists( $params{EXTRA_META} ) );
    die "License not specified"    if ( !exists( $params{LICENSE} ) );
    if ( $params{BUILD_REQUIRES} and ( $eumm_version < 6.5503 ) )
    {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM} = { %{ $params{PREREQ_PM} || {} }, %{ $params{BUILD_REQUIRES} } };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if ( $eumm_version < 6.52 );
    delete $params{MIN_PERL_VERSION}   if ( $eumm_version < 6.48 );
    delete $params{META_MERGE}         if ( $eumm_version < 6.46 );
    delete $params{META_ADD}           if ( $eumm_version < 6.46 );
    delete $params{LICENSE}            if ( $eumm_version < 6.31 );
    delete $params{AUTHOR}             if ( $] < 5.005 );
    delete $params{ABSTRACT_FROM}      if ( $] < 5.005 );
    delete $params{BINARY_LOCATION}    if ( $] < 5.005 );

    WriteMakefile(%params);
}
