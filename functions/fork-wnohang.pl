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

use POSIX ":sys_wait_h";

my @children;

my $pid = fork();
if ($pid) {
    push @children, $pid;
}
else {
    sleep 10;
    exit(0);
}

while (1) {
    my $ret = waitpid $pid, WNOHANG;
    sleep 1;
    next if $ret == 0;
    print $ret, "\n";
    print $?,   "\n";
    print ${^CHILD_ERROR_NATIVE}, "\n";
    exit(0);
}
