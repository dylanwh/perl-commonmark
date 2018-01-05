use strict;
use warnings;

use Test::More tests => 3;

BEGIN {
    use_ok('CommonMarkGFM');
}

is(CommonMarkGFM->version, CommonMarkGFM->compile_time_version,
   'version matches compile_time_version');
is(CommonMarkGFM->version_string, CommonMarkGFM->compile_time_version_string,
   'version_string matches compile_time_version_string');

