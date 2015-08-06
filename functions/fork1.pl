#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: fork1.pl
#
#        USAGE: ./fork1.pl
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
#      CREATED: 2015年07月18日 11时28分52秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my @task = 1 .. 10;
my @children;

foreach (@task) {
    my $pid = fork();
    if ($pid) {
        push @children, $pid;
    }
    else {
        sleep 5;
        exit(0);
    }
}

print wait;
exit();
