#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

use AnyEvent;

my $cv = AnyEvent->condvar;

my $io_watcher = AnyEvent->io(
    fh   => \*STDIN,
    poll => 'r',
    cb   => sub {
        chomp( my $input = <STDIN> );
        warn "read: $input\n";
        if ( $input =~ /^q/i ) {
            $cv->send if $input =~ /^q/i;
        }
        else {
            print "What is the fuck going on!\n";
        }
    },
);

my $time_watcher = AnyEvent->timer(
    after    => 1,
    interval => 1,
    cb       => sub {
        warn "timeout\n";    # print 'timeout' at most every second
    }
);

$cv->recv;                   # wait until user enters /^q/i

$cv->end;

