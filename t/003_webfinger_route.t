use strict;
use warnings;

use Minna::ActivityPub;
use Test::More tests => 3;
use Plack::Test;
use HTTP::Request::Common;

my $app = Minna::ActivityPub->to_app;
my $test = Plack::Test->create($app);
my $url = '/.well-know/webfinger';

# should raise 404
my $res = $test->request(GET $url);
ok($res->code eq 404, '[webfinger] No resource query: 404');

$res = $test->request(GET "$url?resource=actt:random\@localhost");
ok($res->code eq 404, '[webfinger] With inccorect resource query: 404');

# should be ok
$res = $test->request(GET "$url?resource=acct:relay\@localhost");
ok($res->is_success, '[webfinger] With correct resource query: success');