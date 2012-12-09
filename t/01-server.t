#!/usr/bin/env perl6
use Test::ClientServer;

# Returns "ok" from the server code. The server's stdout is piped to the client's stdin, so the
# client has to echo it again.
.run given Test::ClientServer.new(
    client => sub (&callback) { &callback(); say $*IN.get; },
    server => sub (&callback) { use Test; &callback(); plan 1; ok('server code reached'); },
    :timeout(10),
);
