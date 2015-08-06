#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: 1.pl
#
#        USAGE: ./1.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 2015年04月23日 09时59分47秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;


foreach my $i ( 24 .. 29  ) {
    
    foreach my $j ( "01" .. "05" ) {
        my $s = "cn13-d3-rack".$i."-enclosure".$j;
        my $ss = "$s\n" x 14;
        print $ss;
    }
}
