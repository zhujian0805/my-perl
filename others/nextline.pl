#!/usr/bin/perl 
#===============================================================================
#
#         FILE: nextline.pl
#
#        USAGE: ./nextline.pl  
#
#  DESCRIPTION: i
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), jzhu@jz.com
# ORGANIZATION:  CN
#      VERSION: 1.0
#      CREATED: 05/26/2014 04:35:36 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

my $ln = 0;

open(FH, "/tmp/passwd") or die "$!";

while(<FH>){
    if(/root/){
        $ln = $. + 1;
        #print $ln,"\n";
    }

    if($ln == $.){
        print;
        $ln = 0;
    }
}

close(FH);
