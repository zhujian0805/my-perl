#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: sample01.pl
#
#        USAGE: ./sample01.pl
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
#      CREATED: 2016年01月23日 17时00分08秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use IO::Pty;

my $pty = new IO::Pty;

my $slave = $pty->slave;

foreach my $val ( 1 .. 10 ) {
    print $pty "$val\n";
    $_ = <$slave>;
    print "$_";
}

close($slave);
