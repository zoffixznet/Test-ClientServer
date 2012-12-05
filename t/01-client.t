#!/usr/bin/env perl6
use Test::ClientServer;
use Test;
plan 1;

# just returns "ok" from the client code. Does nothing else.
.run given Test::ClientServer.new(
    client => sub (&callback) { &callback(); ok('client code reached') },
    server => sub (&callback) { &callback() }
);
