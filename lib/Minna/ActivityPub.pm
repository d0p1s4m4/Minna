package Minna::ActivityPub;
use Dancer2;
use Crypt::OpenSSL::RSA;
use File::Slurper 'read_text';
use FindBin;

set serializer => 'JSON';

sub read_RSA_key {
    my $rsa_priv_string = read_text("$FindBin::Bin/../priv.key");
    return Crypt::OpenSSL::RSA->new_private_key($rsa_priv_string);
}

my $rsa = read_RSA_key;
my $pubkey = $rsa->get_public_key_x509_string();

my $commit = `git rev-parse HEAD`;
$commit =~ s/^\s+|\s+$//g;

get '/.well-know/webfinger' => sub {
    my $subject = query_parameters->get('resource');
    my $host = request->host;

    if ($subject ne "acct:relay\@$host") {
        # TODO return json
        send_error("Not found", 404);
    }

    my $actor_uri = "https://$host/actor";
    return {
        aliases => [$actor_uri],
        links => [
            {
                href => $actor_uri,
                rel => 'self',
                type => 'application/activity+json'
            },
            {
                href => $actor_uri,
                rel => 'self',
                type => 'application/ld+json; profile="https://www.w3.org/ns/activitystreams"'
            }
        ],
        subject => $subject
    };
};

get '/.well-know/nodeinfo' => sub {
    my $host = request->host;

    return {
        links => [
            {
                rel => 'http://nodeinfo.diaspora.software/ns/schema/2.0',
                href => "https://$host/nodeinfo/2.0.json"
            }
        ]
    };
};

get '/nodeinfo/2.0.json' => sub {
    return {
        openRegistrations => \0,
        protocols => ['activitypub'],
        services => {
            inbound => [],
            outbound => []
        },
        software => {
            name => 'minna-relay',
            version => "0.1 $commit"
        },
        usage => {
            localPosts => 0,
            users => {
                total => 1
            }
        },
        version => '2.0'
    };
};

get '/actor' => sub {
    my $host = request->host;

    return {
        '@context' => 'https://www.w3.org/ns/activitystreams',
        endpoints => {
            sharedInbox => "https://$host/inbox"
        },
        followers => "https://$host/followers",
        following => "https://$host/following",
        inbox => "https://$host/inbox",
        name => 'みんな - RelayBot',
        type => 'Application',
        id => "https://$host/actor",
        publicKey => {
            id => "https://$host/actor#main-key",
            owner => "https://$host/actor",
            publicKeyPem => "$pubkey"
        },
        summary => 'ActivityPub Relay Bot',
        preferredUsername => 'relay',
        url => "https://$host/actor",
        icon => {
            type => 'Image',
            url => "https://$host/images/logo.png"
        }
    };
};

post '/inbox' => sub {

};

true;