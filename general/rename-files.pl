#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: rename.pl
#
#        USAGE: ./rename.pl  
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
#      CREATED: 07/23/2015 03:23:02 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;


my %hash;
foreach(<"0*">){
  my $n = $_;
  $n =~ s/^..-|.py$//g;
  $hash{$n}++;
  my $nf= $n . "-0". $hash{$n}.".py";
  system("mv $_ $nf");
}

