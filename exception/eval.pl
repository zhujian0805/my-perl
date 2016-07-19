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

my $result;
eval {
    $result = 100/0;
};


if ( $@ ) {
    print "failed!!";
    print $@;
    exit(1);
}else{
    print $result;
}

print "END of exection!\n";
