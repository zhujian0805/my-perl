#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: vec_string.pl
#
#        USAGE: ./vec_string.pl
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
#      CREATED: 2015年07月18日 22时29分52秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $extract = vec "Just another Perl hacker,", 1, 8;

printf "I extracted %s, which is the character '%s'\n", $extract, chr($extract);
