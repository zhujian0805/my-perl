#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: unicode-02.pl
#
#        USAGE: ./unicode-02.pl  
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
#      CREATED: 07/27/2015 10:39:29 AM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;

use Encode;
use strict;

my $a = "china----中国";
my $b = "china----中国";
Encode::_utf8_on($a);
Encode::_utf8_off($b);
$a =~ s/\W+//g;
$b =~ s/\W+//g;
print $a, "\n";
print $b, "\n";
