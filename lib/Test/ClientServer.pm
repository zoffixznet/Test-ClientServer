class Test::ClientServer:auth<github:flussence>:ver<2.0.0-pre.2>;

class X::Test::ClientServer is Exception {
    has Int $.timeout;
    method message { "Test timed out after {$.timeout}s"; }
}

has &.server = ...;
has &.client = ...;

#| N.B. This doesn't (and can't) kill the test threads, because that's unsafe.
has Int $.timeout = 30;

method run() {
    my Semaphore $wait .= new(0);
    my $server = start { &.server.({ $wait.release }) };
    my $client = start { &.client.({ $wait.acquire }) };
    my $expire = Promise.in($.timeout);

    for ^3 {
        await Promise.anyof($server, $client, $expire);

        return if $server and $client;
        die X::Test::ClientServer.new(:$.timeout) if $expire;
    }

    !!!
}
