class Test::ClientServer:auth<github:flussence>:ver<2.0.0-pre>;

has &.server = ...;
has &.client = ...;

#| Note that this does NOT kill the test threads (it probably should); it falls out of the block.
has Int $.timeout = 30;

method run() {
    my $wait = Semaphore.new(0);

    # Server and client should invoke the given callbacks whenever they're ready to interact; this
    # ensures the server is up before the client.
    my @workers =
        start({ &.server.({ $wait.release }) }),
        start({ &.client.({ $wait.acquire }) });

    # Wait $.timeout seconds, or until those have both exited
    await Promise.anyof( Promise.in($.timeout), Promise.allof(|@workers) );
}
