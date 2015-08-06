#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: fine-company-related.pl
#
#        USAGE: ./fine-company-related.pl  
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
#      CREATED: 08/05/2015 09:14:40 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $filename = $ARGV[0];

open(FH, $filename) or die "$!";

while(<FH>){
  if(/blizzard|battle|jzhu|\d{2,}\.\d{2,}\.\d{2,}/){
    print $filename,"\n";
  }
}

close(FH);
