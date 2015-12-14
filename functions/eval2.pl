#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: eval2.pl
#
#        USAGE: ./eval2.pl
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
#      CREATED: 2015年07月16日 20时09分27秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $a = '100 + 200';

my $aa;
eval { $aa = $a; };
print $aa, "\n";
if ($@) {
    print $@;
}

my $c;
$c = eval "$a";
print $c, "\n";
if ($@) {
    print $@;
}
