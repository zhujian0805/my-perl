#!/usr/bin/perl 
#===============================================================================
#
#         FILE: caller.pl
#
#        USAGE: ./caller.pl
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
#      CREATED: 2014年11月21日 17时10分07秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;

print &tester1();

sub tester1 {
    my @array = caller(0);
    print "-----tester1\n";
    &tester2();
    print Dumper \@array;
}

sub tester2 {
    my @array = caller(1);
    print Dumper \@array;
    print "-----tester2\n";
    &tester3();
}

sub tester3 {
    my @array = caller(1);
    print "-----tester3\n";
    print Dumper \@array;
}
