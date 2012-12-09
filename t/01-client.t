#!/usr/bin/env perl6
use Test::ClientServer;

# Just returns "ok" from the client code. Does nothing else.
.run given Test::ClientServer.new(
    client => sub (&callback) { use Test; &callback(); plan 1; ok('client code reached'); },
    server => sub (&callback) { &callback() },
    :timeout(10),
);
