package Minna;
use Dancer2;
use FindBin;
use DBI;

our $VERSION = '0.1';

get '/' => sub {
    my $db = DBI->connect("dbi:SQLite:dbname=$FindBin::Bin/../db.sqlite") or die DBI::errstr;
    my $query = $db->prepare('SELECT COUNT(*) FROM following') or die $db->errstr;
    $query->execute() or die $query->errstr;
    my ($count_registered) = $query->fetchrow_array;

    $query = $db->prepare('SELECT COUNT(*) FROM ban') or die $db->errstr;
    $query->execute() or die $query->errstr;
    my ($count_banned) = $query->fetchrow_array;
    template 'index' => {
        'title' => 'みんな - ActivityPub Relay',
        'count_registered' => $count_registered,
        'count_banned' => $count_banned
    };
};

true;