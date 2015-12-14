#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: check_default_gateway.pl
#
#        USAGE: ./check_default_gateway.pl
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
#      CREATED: 2015年10月02日 19时54分58秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;

my $IP= '/sbin/ip addr';
my @ips= `$IP`;
my %interfaces;

my $interface;
my $HWaddr;
my $Number;
foreach (@ifconfig) {
    if ( /(\d): (\S+):/ ) {
      $Number = $1;
      $interface = $2;
      $interfaces{$Number}{name} = $interface;
    }
    if ( /link\/ether d8default3:85:77break9:50/ ) {
}

print Dumper \%interfaces;
