#!/usr/bin/env perl6
use Test::ClientServer;
use Test;

plan 1;

# Ensure that the timeout kills the processes in a reasonable amount of time
my $start = now;

# Simulate a server taking too long to start
.run given Test::ClientServer.new(
    :timeout(3),
    server => sub (&callback) { sleep 10; &callback(); diag 'Server code ran to end' },
    client => sub (&callback) { &callback(); diag 'Client code ran to end' },
);

my $end = now - $start;

ok(3 < $end < 10, 'Timeout works sanely') or diag("Failure: 3 < $end < 10");
