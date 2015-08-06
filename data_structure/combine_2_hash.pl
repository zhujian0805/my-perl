#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: combine_2_hash.pl
#
#        USAGE: ./combine_2_hash.pl
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
#      CREATED: 07/20/2015 03:59:23 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;

my %hash1 = ( 'a' => 1, 'b' => 2 );
my %hash2 = ( 'c' => 1, 'd' => 2 );

my %hash3 = ( %hash1, %hash2 );

print Dumper \%hash3;
