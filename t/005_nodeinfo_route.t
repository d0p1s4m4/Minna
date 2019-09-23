use strict;
use warnings;

use Minna::ActivityPub;
use Test::JSON::More;
use Test::More tests => 2;
use Plack::Test;
use HTTP::Request::Common;

my $app = Minna::ActivityPub->to_app;
my $test = Plack::Test->create($app);

my $res = $test->request(GET '/nodeinfo/2.0.json');
ok($res->is_success, '[GET /nodeinfo/2.0.json] successful');

ok_json $res->content;