use strict;
use warnings;

use Minna;
use Test::More tests => 1;
use Plack::Test;
use HTTP::Request::Common;

my $app = Minna->to_app;
my $test = Plack::Test->create($app);
my $res = $test->request(GET '/actor');
ok($res->is_success, '[GET /actor] successful');