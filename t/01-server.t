#!/usr/bin/env perl6
use Test::ClientServer;

# Returns "ok" from the server code. The server's stdout is piped to the client's stdin, so the
# client has to echo it again. Yes I know this is stupid.
.run given Test::ClientServer.new(
    client => sub (&callback) { &callback(); .say for $*IN.lines; },
    server => sub (&callback) { use Test; &callback(); plan 1; ok('server code reached'); },
    :timeout(10),
);
