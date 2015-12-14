#!/usr/bin/perl 
#===============================================================================
#
#         FILE: findip.pl
#
#        USAGE: ./findip.pl  
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
#      CREATED: Thursday, December 19, 2013 08:34:10 CST
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Net::IP::AddrRanges;
use Data::Dumper;
use File::Basename;

sub buildIpRange{
    my $filename = shift;
    my $ranges = Net::IP::AddrRanges->new();
    open(FH, $filename) or die "$!";
    my @range;
    while(<FH>){
        chomp;
        my @ary = split;
        my $range = $ary[0] . "-" . $ary[1];
        push @range, $range;

    }
    close(FH);
    $ranges->add(@range);
    return $ranges;
}

#MAIN

my $fname = $ARGV[0];
my $rg_ct = &buildIpRange($fname);
my $bname = basename($fname, ".txt");
open(FH, "players.ip") or die "$!";
while(<FH>){
    s/^ *| *$//g;
    s/^ *| *\n$//g;
    if($rg_ct->find($_)){
        print $bname . "    " , $_, "\n";
    }
}
close(FH);
