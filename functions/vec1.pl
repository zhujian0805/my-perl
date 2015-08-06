#!/usr/bin/perl 
#===============================================================================
#
#         FILE: vec1.pl
#
#        USAGE: ./vec1.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), jzhu@jz.com
# ORGANIZATION:  CN
#      VERSION: 1.0
#      CREATED: Friday, September 27, 2013 11:13:55 CST
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

my $foo = '';
vec( $foo, 0, 16 ) = 0x5065;

print $foo, "\n";

#print vec($foo, 0, 8) , "\n";

vec( $foo, 1, 32 ) = 0x5065726C;

print $foo, "\n";
