#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: class-variable.pl
#
#        USAGE: ./class-variable.pl  
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
#      CREATED: 07/19/2017 03:56:54 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use Data::Dumper;

my $dd =  "Data::Dumper";
my $a = "pearl";
my $b = [ $a ];
my $c = { 'b' => $b };
my $d = [ $c ];
my $e = { 'd' => $d };
my $f = { 'e' => $e };
print $dd->Dump([$f], [qw(f)]);
