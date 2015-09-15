#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: test.pl
#
#        USAGE: ./test.pl  
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
#      CREATED: 09/15/2015 01:39:34 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;

open FH, "thread-4187992-1-1.txt" or die "$!";

while(<FH>){
  my @fields = split;
  my @array = ();

  if($#fields <= 2){
    print "nooo";
  }else{
    my $i;
    for ( $i=0; $i<=$#fields-2; $i++ ) {
      if($i==0){
        push @array, $fields[$i] . '+'. $fields[$i+1];
        push @array, $fields[$i] . "-" . $fields[$i+1] . "+" . $fields[$i+2];
      }else{
        push @array, $fields[$i] . "-" . $fields[$i+1] . "+" . $fields[$i+2];
      }
    }
    push @array, $fields[$i] . "-" . $fields[$i+1];
  }

  print "@array", "\n";

}

close FH;
