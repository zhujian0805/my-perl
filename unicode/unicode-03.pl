#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: unicode-03.pl
#
#        USAGE: ./unicode-03.pl  
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
#      CREATED: 07/27/2015 11:44:14 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Encode qw/decode encode/;

my $string = "中国人";

binmode STDOUT, ':utf8';
print length($string),"\n";
print $string,"\n";
print "\n";
print "\n";

my $de_string = Encode::encode("utf8", $string);
print length($de_string),"\n";
print $de_string,"\n";
print "\n";
print "\n";

my $en_string = Encode::decode("utf8", $de_string);
print length($de_string),"\n";
print $en_string,"\n";
print "\n";
print "\n";
