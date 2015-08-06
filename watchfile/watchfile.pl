#!/usr/bin/perl 
#===============================================================================
#
#         FILE: watchfile.pl
#
#        USAGE: ./watchfile.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), jzhu@jz.com
# ORGANIZATION:  CN
#      VERSION: 1.0
#      CREATED: Thursday, September 26, 2013 12:25:29 CST
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

my $lastpos = 0;

sub readfiles 
{
    my $file = shift;
    open FH, "<", $file or die "openfile error: $!";
    seek FH, $lastpos, 0;
    while(<FH>){
        print
    }
    $lastpos = tell FH;
    close FH;
}

while ( 1 ) {
    
    my $thefile = $ARGV[0];
    
    &readfiles($thefile); 

    select(undef, undef, undef, 0.01);

}
