#!/usr/bin/perl 
use strict;
use warnings;

open( FH, "./cn-enclosure.ldif" ) or die "$!";

while (<FH>) {

    if (/^dn.*location=(.*?),.*/) {
        if ( $. == 3 ) {
            print $1 . " ";
        }
        else {
            print "\n", $1 . " ";
        }
    }

    if (/^interface.*mm.=(.*)/) {
        print $1. " ";
    }
}

print "\n";

close(FH);
