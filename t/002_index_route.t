use strict;
use warnings;

use Minna;
use Test::More tests => 3;
use Plack::Test;
use HTTP::Request::Common;
use Ref::Util qw<is_coderef>;

my $app = Minna->to_app;
ok(is_coderef($app), 'Got app');

my $test = Plack::Test->create($app);
my $res  = $test->request(GET '/');

ok($res->is_success, '[GET /] successful');

my $content_size = length $res->content;
ok($content_size > 0, '[GET /] not empty page');