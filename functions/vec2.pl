#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: vec2.pl
#
#        USAGE: ./vec2.pl
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
#      CREATED: 2014年08月24日 09时31分06秒
#     REVISION: ---
#===============================================================================
#
# explanation:
# http://blog.sina.com.cn/s/blog_c44d1b0d0101bp6k.html
#
# Mastering Perl:
# http://chimera.labs.oreilly.com/books/1234000001527/ch16.html

use strict;
use warnings;
use utf8;

my $foo = '';
vec( $foo, 0, 32 ) = 0x5065726C;    # 'Perl'

# $foo eq "Perl" eq "\x50\x65\x72\x6C", 32 bits
print vec( $foo, 0, 8 );            # prints 80 == 0x50 == ord('P')

vec( $foo, 2, 16 ) =
  0x5065;   # 'PerlPe' BITS=16, 按照16bits为一个单位，就是:2*16=32bits
vec( $foo, 3, 16 ) = 0x726C;    # 'PerlPerl', 同上
vec( $foo, 8, 8 ) = 0x50;  # 'PerlPerlP' 按照8bits为一个单位，8*8=64bits
vec( $foo, 9, 8 ) = 0x65;  # 'PerlPerlPe' 同上
vec( $foo, 20, 4 ) = 2;  # 'PerlPerlPe'   . "\x02" 按照4bits为一个单位，
vec( $foo, 21, 4 ) = 7
  ; # 'PerlPerlPer' 按照4bits为一个单位，和上面的凑8bits，等于字符'r'
    # 'r' is "\x72"
vec( $foo, 45, 2 ) =
  3;    # 'PerlPerlPer'  . "\x0c" BITS小于4, 看下面"__DATA__"处的解释,
vec( $foo, 93, 1 ) = 1
  ; # 'PerlPerlPer'  . "\x2c" 这里把最后8bits拆解为4部分，2*2+1*2+1*2 = 8bits
vec( $foo, 94, 1 ) = 1;    # 'PerlPerlPerl'
                           # 'l' is "\x6c"

__DATA__
>>> bin(0x6c)
'0b1101100'
>>> 01101100
>>> 
>>> hex(0b1100)
'0xc'
>>> hex(0b10)
'0x2'
>>> hex(0b0110)
  '0x6'

