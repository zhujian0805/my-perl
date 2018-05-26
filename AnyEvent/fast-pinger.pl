use AnyEvent::Socket;
use AnyEvent::FastPing;

my $done = AnyEvent->condvar;

my $pinger = new AnyEvent::FastPing;

if(AnyEvent::FastPing::ipv4_supported)
{ 
    print "Support Ipv4"; 
}else{
    print "Not Support Ipv4"; 
}


$pinger->interval( 1 / 1000 );
$pinger->max_rtt(0.1);    # reasonably fast/reliable network

$pinger->add_range(192.168.0.0, 192.168.0.255, 1/100);

$pinger->on_recv(
    sub {
        for ( @{ $_[0] } ) {
            printf "%s %g\n", ( AnyEvent::Socket::format_address $_->[0] ),
              $_->[1];
        }
    }
);

$pinger->on_idle(
    sub {
        print "done\n";
        undef $pinger;
    }
);

$pinger->start;
$done->wait;
