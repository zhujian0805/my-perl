#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: eval.pl
#
#        USAGE: ./eval.pl
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
#      CREATED: 07/16/2015 08:31:49 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;

my %hash = ( a => 1, b => 2 );
print Dumper \%hash;

open( EV, 'eval.txt' );

my $hh = { eval join( '', <EV> ) };

print Dumper $hh;
