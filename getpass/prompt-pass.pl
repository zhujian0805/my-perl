#!/usr/bin/perl 
#===============================================================================
#
#         FILE: prompt-pass.pl
#
#        USAGE: ./prompt-pass.pl  
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
#      CREATED: 2014年10月31日 22时06分25秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

print "Input you password:";

system('stty','-echo');
chop( my $password=<STDIN>);
system('stty','echo');

print "\nyour password is:", $password,"\n";
