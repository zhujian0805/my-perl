#!/usr/bin/perl 
#===============================================================================
#
#         FILE: repeat.pl
#
#        USAGE: ./repeat.pl  
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
#      CREATED: 2014年11月11日 14时30分56秒
#     REVISION: ---
#===============================================================================

sub repeat (&f, $n) { f() xx $n };
 
sub example { say rand }
 
repeat(&example, 3);
