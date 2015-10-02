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

my $IFCONFIG = '/sbin/ifconfig';
my @ifconfig = `$IFCONFIG`;
my %interfaces;

my $interface;
my $HWaddr;
foreach (@ifconfig) {
    if ( /(.*)\s+Link encap.*HWaddr/ .. /^$/ ) {
        if ( /(.*)\s+Link encap.*HWaddr\s.*(..:..:..:..:..:..)/) {
            $interface = $1;
            $HWaddr = $2;
            $interface =~ s/\s.*//g;
            $interfaces{$interface}{HWaddr} = $HWaddr;
        }
        elsif (/inet addr:(\d{1,}.\d{1,}.\d{1,}.\d{1,})  Bcast:(\d{1,}.\d{1,}.\d{1,}.\d{1,})  Mask:(\d{1,}.\d{1,}.\d{1,}.\d{1,})/)
        {
            $interfaces{$interface}{ipaddr} = $1;
            $interfaces{$interface}{bcast}  = $2;
            $interfaces{$interface}{mask}   = $3;
        }
    }
}

print Dumper \%interfaces;
