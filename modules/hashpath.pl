#!/usr/bin/perl 
#===============================================================================
#
#         FILE: hashpath.pl
#
#        USAGE: ./hashpath.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2014年11月25日 21时46分26秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Hash::Path qw(hash_path);

my %hash = ( a => ( b => ( c=> 1)));
my $scalar = hash_path(\%hash, ['a', 'b', 'c']);

print $scalar,"\n";
