#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: unicode-09.pl
#
#        USAGE: ./unicode-09.pl  
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
#      CREATED: 07/28/2015 06:11:36 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Encode qw/encode decode/;

my $str = '你好，我们爱你';

binmode STDOUT, ':utf8';

## print directly
print $str,"\n";

open FH, "> /tmp/$0.log";
binmode FH, ':utf8';
print FH $str;
close FH;

# print without decode
open FH, "/tmp/$0.log";
while(<FH>){
  print ;
  print "\n";
}
close FH;

# print without utf8 turned on
open FH, "/tmp/$0.log";
while(<FH>){
  Encode::_utf8_on($_);
  print ;
  print "\n";
}
close FH;

# print without decode(to utf8 here since we used 'use utf8', and the locale should utf8
# otherwise it maight print wrong
open FH, "/tmp/$0.log";
while(<FH>){
  print decode("utf8", $_);
  print "\n";
}
close FH;
