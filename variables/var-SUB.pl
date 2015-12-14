#!/usr/bin/perl 
#===============================================================================
#
#         FILE: var-SUB.pl
#
#        USAGE: ./var-SUB.pl  
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
#      CREATED: 2014年11月23日 21时55分07秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use 5.16.0;
use feature 'current_sub';
use Data::Dumper;


&test();

sub test{

    print __SUB__,"\n";

}
