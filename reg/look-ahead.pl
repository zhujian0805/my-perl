#!/usr/bin/perl 
#===============================================================================
#
#         FILE: test-reg1.pl
#
#        USAGE: ./test-reg1.pl
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
#      CREATED: 2014年11月21日 14时13分31秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

while (<DATA>) {
    # Note here, the '.*...' means not match anything end with vip/compute
    if (/abc(?!.*(vip|compute))/) {
        print;
    }
}

__DATA__
abcldjfvip
abcsdfcompute
abcalsjdfl
abcalskdjf
abcdsfsdf
abcadfjsdf
