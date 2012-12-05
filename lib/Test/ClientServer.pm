class Test::ClientServer;
# vim: set tw=80 :
# This entire class is a workaround for not having &fork. The workaround is
# completely insane and liable to break if you look at it funny. Don't try
# anything more complicated than the module's own tests because horrible things
# will happen.

enum ForkDirection <parent server client>;

has &!client = { fail 'client code not defined' };
has &!server = { fail 'server code not defined' };
has Int $!timeout = 60;

method run() {
    if !defined(my $pid = self.spork()) {
        exit;
    }
    elsif $pid > 0 {
        &!server({ sleep 1 });
    }
    else {
        &!client({ sleep 5 });
    }
}

method spork() returns ForkDirection {
    given %*ENV<TEST_CLIENTSERVER_FORK> // Nil {
        return ForkDirection::server when 'server';
        return ForkDirection::client when 'client';
    }

    run(q:c:to<FI>);
        ( TEST_CLIENTSERVER_FORK="server" perl6 {$?FILE} ) & \
        server_pid=$! \
        ( TEST_CLIENTSERVER_FORK="client" perl6 {$?FILE} ) & \
        client_pid=$! \
        sleep {$!timeout} \
        kill $server_pid $client_pid
    FI

    return ForkDirection::parent;
}
