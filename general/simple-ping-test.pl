#!/usr/bin/perl
use strict;
use warnings;

while (1) {
    my @ips = qw/8.8.8.8/;
    foreach my $ip (@ips) {
        my @result = `ping -W 1 -c 1 $ip`;
        my $loss;
        my $delay;
        foreach (@result) {
            $delay = $_ if /bytes from/;
            $loss  = $_ if /packets trans/;
        }
        my $tm = `date`;
        chomp $tm;
        my $ls = $loss;
        $loss =~ s/.*received,|%.*packet loss.*//g;
        if ( $loss > 0 ) {
            open( FH, ">>$ip.log" ) or die;
            print FH $ip . " " . $tm . " " . $ls;
            close FH;
        }
        else {
            open( FH, ">>$ip.log" ) or die;
            print FH $ip . " " . $tm . " " . $delay;
            close FH;
        }
    }
    sleep 5;
}
