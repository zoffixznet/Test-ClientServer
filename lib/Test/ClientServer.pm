class Test::ClientServer;

has &!client = fail 'client code not defined';
has &!server = fail 'server code not defined';
has Int $!timeout = 60;

method run() {
    spork ?? &!client()
          !! &!server()
}

sub spork() {
    if &fork {
        ??? ('This code is not Y2038-compliant. Please consult the manual.');
    }
    else {
        say $?FILE;
    }
}
