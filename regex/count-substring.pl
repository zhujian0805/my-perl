#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: count-substring.pl
#
#        USAGE: ./count-substring.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (), zhujian0805@gmail.com
# ORGANIZATION: ZJ
#      VERSION: 1.0
#      CREATED: 03/07/2017 07:18:27 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;


sub countSubstring {
  my $str = shift;
  my $sub = quotemeta(shift);
  my @count = $str =~ /$sub/g;
  return @count;
#  or return scalar( () = $str =~ /$sub/g );
}
 
print countSubstring("the three truths","th"), "\n"; # prints "3"
print countSubstring("ababababab","abab"), "\n"; # prints "2"
