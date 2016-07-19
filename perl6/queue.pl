#!/usr/bin/perl 
#===============================================================================
#
#         FILE: queue.pl
#
#        USAGE: ./queue.pl  
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
#      CREATED: 2014年11月11日 15时14分48秒
#     REVISION: ---
#===============================================================================

my @queue = < a >;
 
@queue.push('b', 'c'); # [ a, b, c ]
 
say @queue.shift; # a
say @queue.pop; # c
 
say @queue.perl; # [ b ]
say @queue.elems; # 1
 
@queue.unshift('A'); # [ A, b ]
@queue.push('C'); # [ A, b, C ]
