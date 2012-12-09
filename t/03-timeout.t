#!/usr/bin/env perl6
use Test::ClientServer;

# Ensure that the timeout kills the processes in a reasonable amount of time
my $start = time;

.run given Test::ClientServer.new(
    client => sub (&callback) { &callback(); sleep 20; },
    server => sub (&callback) { &callback(); sleep 20; },
    :timeout(8),
);

exit if defined %*ENV<TEST_CLIENTSERVER>;

use Test;
plan 1;
ok(time - $start < 15, 'timeout functions');
