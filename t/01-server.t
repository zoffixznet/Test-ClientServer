#!/usr/bin/env perl6
use Test::ClientServer;

# Returns "ok" from the server code.
.run given Test::ClientServer.new(
    client => sub (&callback) { &callback(); },
    server => sub (&callback) { use Test; &callback(); plan 1; pass('server code reached'); },
    :timeout(10),
);
