#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: thread-4181789-1-1.pl
#
#        USAGE: ./thread-4181789-1-1.pl
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
#      CREATED: 2015年07月08日 22时01分31秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;

my %hash;

while (<ARGV>) {
    my @fields = split;
    push @{ $hash{ $fields[0] } }, $fields[1];
}

print Dumper \%hash;

foreach my $k ( keys %hash ) {
    print $k, "\t";
    if (scalar @{$hash{$k}} == 1){
      print 0,"\t", @{$hash{$k}};
    }else{
      print $_,"\t" foreach(@{$hash{$k}});
    }
    print "\n";
}
