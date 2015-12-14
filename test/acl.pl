#!/usr/bin/perl 
#===============================================================================
#
#         FILE: acl.pl
#
#        USAGE: ./acl.pl  
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
#      CREATED: Friday, September 27, 2013 02:27:30 CST
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Data::Dumper;


open(FH, $ARGV[0]) or die "open file error $!";

my %hash;

while(<FH>){
    
    next if(/ffff/);
    next if(/127\.0\.0/);
    my @cols = split;
    my $col1 = $cols[0];
    my $col2 = $cols[1];
    $col1 =~ s/:.*//;
    $col2 =~ s/:.*//;

    $hash{$col2} = $col1;


}


foreach my $k (keys %hash) {

    print $k, " ", $hash{$k}, "\n";

}



