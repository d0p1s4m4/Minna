use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'Minna',
    AUTHOR              => q{d0p1 <contact@d0p1.eu>},
    VERSION_FROM        => 'lib/Minna.pm',
    ABSTRACT            => 'ActivityPub Relay',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'bsd')
      : ()),
    PL_FILES            => {},
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Minna-*' },
);
