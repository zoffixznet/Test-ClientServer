#!/usr/bin/env perl6
use Test::ClientServer;
use Test;
plan 1;

# I didn't feel like writing complicated free-port-finding code, so let's just
# hope nobody's still running XFree86.
my $port = 7100;

# do a simple echo server, like S32-io/IO-Socket-INET.t does.
.run given Test::ClientServer.new(
    # :client is a sub that takes one argument, a callback that's supposed to
    # block until the server becomes ready.
    client => sub (&client-ready-callback) {
        my $socket = IO::Socket::INET.new(
            :localhost('127.0.0.1'),
            :localport($port),
        );

        &client-ready-callback();

        my Str $sent = ('a'..'z').join;
        $socket.send($sent);
        my $received = $socket.recv();

        is($received, $sent, 'echo test');
    },
    # :server is similar to :client, but it should call the callback to signal
    # that it's ready itself.
    server => sub (&server-ready-callback) {
        my $socket = IO::Socket::INET.new(
            :localhost('127.0.0.1'),
            :localport($port),
            :listen
        );

        &server-ready-callback();

        my $client = $socket.accept();
        my $buf = $client.recv();
        $client.send($buf);
        $client.close();
    },
    # :timeout is 60 seconds by default. If anything is still running by then
    # it's killed.
    timeout => 20
);
