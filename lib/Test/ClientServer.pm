class Test::ClientServer;
# vim: set tw=80 :

# This entire class is an insane hack to work around not having &fork. Don't do
# anything complicated with it, and don't do anything with stdin/stdout.
#
# If &fork (or maybe threads) is added, the internals should become
# significantly more sane while the API stays the same. Hopefully.

enum ForkDirection <parent server client>;

has $.client = ...;
has $.server = ...;
has $.timeout = 30;

method run() {
    # We have the server tell the client it's ready by using a pipe.
    my &server-callback = { $*ERR.say: 'ready'; };
    my &client-callback = { while $*IN.get -> $_ { last when 'ready'; .say } };

    given self.spork() {
        when ForkDirection::parent {
            return;
        }
        when ForkDirection::server {
            $.server.(&server-callback);
            exit;
        }
        when ForkDirection::client {
            $.client.(&client-callback);
            exit;
        }
    }
}

method spork() returns ForkDirection {
    given %*ENV<TEST_CLIENTSERVER> // Nil {
        return ForkDirection::server when 'server';
        return ForkDirection::client when 'client';
    }

    my $invocation = 'perl6 -Ilib "' ~ $*PROGRAM_NAME ~ '"';
    shell(join(q{ },
        'TEST_CLIENTSERVER="server" ' ~ $invocation ~ ' 2>&1 |',
        'TEST_CLIENTSERVER="client" ' ~ $invocation ~ ' &',
        'pid=$!;',
        '( sleep ' ~ $.timeout ~ '; kill $pid 2>/dev/null ) &',
        'wait $pid 2>/dev/null; kill $!',
    ));

    return ForkDirection::parent;
}
