#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

use AnyEvent;

my $cv = AnyEvent->condvar;

my $io_watcher = AnyEvent->io (
   fh   => \*STDIN,
   poll => 'r',
   cb   => sub {
      warn "io event <$_[0]>\n";   # will always output <r>
      chomp (my $input = <STDIN>); # read a line
      warn "read: $input\n";       # output what has been read
      $cv->send if $input =~ /^q/i; # quit program if /^q/i
   },
);

my $time_watcher = AnyEvent->timer (after => 1, interval => 1, cb => sub {
   warn "timeout\n"; # print 'timeout' at most every second
});

$cv->recv; # wait until user enters /^q/i

$cv->end;


