#!/usr/bin/perl 
#===============================================================================
#
#         FILE: datawalk.pl
#
#        USAGE: ./datawalk.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2014年11月25日 15时31分38秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Walk;

my %hash = ( a => ( k => 11, h => 19 ), b => ( f => 33 ) );

foreach ( keys %hash ) {
    print $_,"\t";
    walk \&ckandchg, $hash{$_};
    print "\n";
}

sub ckandchg {
    print "$_ \t";
}
