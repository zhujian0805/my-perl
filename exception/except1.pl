#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: eval.pl
#
#        USAGE: ./eval.pl  
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
#      CREATED: 2014年09月11日 18时20分11秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my $cmd = 'non-exit';

my @output = `$cmd 2>&1`;

my $ret = $? >> 8;

if ( $ret != 0 ) {
    print "failed!!";
    exit(1);
}else{
    print @output;
}

print "END of exection!\n";
