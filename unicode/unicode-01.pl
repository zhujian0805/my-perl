#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: unicode-01.pl
#
#        USAGE: ./unicode-01.pl
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
#      CREATED: 07/27/2015 10:38:26 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Encode;

my $str = "中国123";
Encode::_utf8_on($str);
print length($str) . "\n";
Encode::_utf8_off($str);
print length($str) . "\n";
