#!/usr/bin/perl 
#===============================================================================
#
#         FILE: thread-4148675-1-1.pl
#
#        USAGE: ./thread-4148675-1-1.pl  
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
#      CREATED: 2014年08月03日 22时28分43秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Data::Dumper;

my @a;

while ( <DATA> ) {

    if (/^#P.*r(\d+) .*/) {
        if ( $1 >= 4200 ) {
            push @a, $_;
        }
    }
}

print Dumper \@a;

#文本$file="d:/temp/inf" 里面的内容如下：
#我想把文本中的某些行写到一个数组里面@a里面去，但是要满足条件（句首必须是#P,字母r后面的数字要大于4000）求解？
__DATA__
### Layer - drl features data ###
#P 203.09967 210.222845 r650 P 1 0 N;.bit=0.65,.drill=plated
#P 203.09967 216.039445 r650 P 1 0 N;.bit=0.65,.drill=plated
#P 213.7973875 207.212945 r950 P 2 0 N;.bit=0.95,.drill=plated
#P 213.7973875 209.7128125 r950 P 2 0 N;.bit=0.95,.drill=plated
#P 213.7973875 211.71281 r950 P 2 0 N;.bit=0.95,.drill=plated
#P 213.7973875 214.21293 r950 P 2 0 N;.bit=0.95,.drill=plated
#P 220.3886875 209.097625 r350 P 3 0 N;.bit=0.35,.drill=plated
#P 239.967 215.485725 r450 P 4 0 N;.bit=0.45,.drill=plated
#P 207.8106075 217.776805 r450 P 4 0 N;.bit=0.45,.drill=plated
#P 203.4976875 217.809825 r450 P 4 0 N;.bit=0.45,.drill=plated
#P 252.6641475 247.505185 r450 P 4 0 N;.bit=0.45,.drill=plated
#L 299.6796875 245.8001875 275.336 245.8001875 r4500 P 5 ;.bit=4.50,.drill=plated
#P 294.0231575 235.4097475 r4200 P 0 0 N
