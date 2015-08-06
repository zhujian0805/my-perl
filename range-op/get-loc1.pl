#!/usr/bin/perl 
use strict;
use warnings;

open( FH, "./cn-enclosure.ldif" ) or die "$!";

while (<FH>) {

    if (/^dn.*location=(.*?),.*/ ... /^$/ and !/^$/) {
        print
    }
}

print "\n";

close(FH);
