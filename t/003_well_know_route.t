use strict;
use warnings;

use Minna::ActivityPub;
use Test::JSON::More;
use Test::More tests => 6;
use Plack::Test;
use HTTP::Request::Common;

my $app = Minna::ActivityPub->to_app;
my $test = Plack::Test->create($app);

# webfinger Test
my $url = '/.well-know/webfinger';

# should raise 404
my $res = $test->request(GET $url);
ok($res->code eq 404, "[GET $url] No resource query: 404");

$res = $test->request(GET "$url?resource=actt:random\@localhost");
ok($res->code eq 404, "[GET $url] With inccorect resource query: 404");

# should be ok
$res = $test->request(GET "$url?resource=acct:relay\@localhost");
ok($res->is_success, "[GET $url] With correct resource query: success");
ok_json $res->content;

# nodeinfo test
$url = '/.well-know/nodeinfo';

$res = $test->request(GET $url);
ok($res->is_success, "[GET $url] successful");
ok_json $res->content;