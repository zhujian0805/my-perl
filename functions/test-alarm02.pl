while (1) {

    #warn "SCP $server TRY  $attempts attempt(s)\n";
    #`scp $server\:/home/mwilson/*_$logtime\.log /var/data/CN/logs/$logtime/`;
    select( undef, undef, undef, .1 );
    local $SIG{ALRM} = sub {
        select( undef, undef, undef, .1 );
        die "SCP $server FAIL $attempts attempt(s) $logtime\n";
    };    # NB: \n required
    eval {
        alarm 3;
        while (1) {
            `scp 10.129.248.36:/tmp/testing.txt /tmp/`;
        }
        alarm 0;
    };
    if ($@) {
        print $@, "\n";
        $attempts++;
        $@ = '';
    }
    else {
        last;
    }
}

