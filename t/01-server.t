#!/usr/bin/env perl6
use Test::ClientServer;
use Test;
plan 1;

# just returns "ok" from the server code
.run given Test::ClientServer.new(
    client => sub (&callback) { &callback() },
    server => sub (&callback) { &callback(); ok('server code reached') }
);
