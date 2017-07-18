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
#       AUTHOR: James Zhu (), zhujian0805@gmail.com
# ORGANIZATION: ZJ
#      VERSION: 1.0
#      CREATED: 07/18/2017 08:55:43 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $i = 'abc';

my $r = "\u$i";

print $r;
