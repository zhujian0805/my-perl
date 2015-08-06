#!/usr/bin/perl 
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
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2014年11月24日 19时42分51秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;


&ttt(1,2,3,4,5);

sub ttt{
    my ($a, @ary) = @_;
    print Dumper \$a;
    print Dumper \@ary;
    shift @ary;
    print Dumper \@ary;
}
