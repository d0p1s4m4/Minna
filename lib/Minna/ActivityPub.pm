package Minna::ActivityPub;
use Dancer2;
set serializer => 'JSON';

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
            publicKeyPem => 'TODO pubkey'
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