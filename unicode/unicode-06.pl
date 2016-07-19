#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

open FH, "test.txt";

while(<FH>){
  if(utf8::is_utf8($_)){
    print "YES\n";
  }
  Encode::_utf8_on($_);
  if(utf8::is_utf8($_)){
    print "Turned on\n";
    print;
  }
}

close FH;
