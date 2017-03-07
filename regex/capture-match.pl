#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: capture-match.pl
#
#        USAGE: ./capture-match.pl  
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
#      CREATED: 03/07/2017 07:07:02 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my @cmd = `ifconfig`;

foreach(@cmd){
    if(/.*addr:((\d+)\.(\d+)\.(\d+)\.(\d+)).*/){
        print $1, "\n";
    }
}
