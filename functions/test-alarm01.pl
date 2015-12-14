#!/usr/bin/perl 
use strict;
use warnings;
use utf8;

while (1) {
    eval {
        local $SIG{ALRM} =
          sub { print "This is died\n"; die "alarm\n"; print "died\n"; }; # NB: \n required
        alarm 5;
        my $count = 0;
        while (1) {
            $count += 1;
            `echo testing $count >> $0.log`;
        }

        alarm 0;
    };
    if ($@) {
        print $@, "\n";
        die unless $@ eq "alarm\n";    # propagate unexpected errors
        $@ = '';
    }
    else {
        print "NO die\n";
    }
}
