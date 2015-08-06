#!/usr/bin/perl
use strict;
use warnings;

open FH, "test.txt";

while(<FH>){
  if(/中/){
    print;
  }else{
    print "NO\n";
  }
}

close FH;
