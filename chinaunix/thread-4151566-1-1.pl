#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: thread-4151566-1-1.pl
#
#        USAGE: ./thread-4151566-1-1.pl
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
#      CREATED: 2014年08月23日 20时54分07秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

my %hash;
my $biggest = 0;
my $the_line;

while (<DATA>) {
    next unless (/ATOM/);
    my @cols = split;
    my $sum  = abs( $cols[7] ) + abs( $cols[8] ) + abs( $cols[9] );
    print $sum, "\n";
    if ( $biggest < $sum ) {
        $biggest  = $sum;
        $the_line = $_;
    }
}

print $the_line, "\n";

__DATA__
ATOM   1422    N GLY A 197     -10.623  18.492 -15.590  1.00 23.85           N 0
ATOM   1389    O ARG A 193     -10.566  15.975 -16.255  1.00 28.14           O 0
ATOM   1423   CA GLY A 197     -11.277  19.423 -16.488  1.00 20.28           C 0
ATOM   1414    O ARG A 196      -8.666  19.596 -15.673  1.00 25.71           O 0
ATOM   1413    C ARG A 196      -9.352  18.667 -15.250  1.00 26.19           C 0
ATOM   1415   CB ARG A 196      -7.830  16.684 -15.028  1.00 32.78           C 0
ATOM   3375   CA GLY B  52     -12.202  18.244 -24.755  1.00 40.16           C 0
ATOM   3368    O GLU B  51     -14.073  16.542 -23.681  1.00 47.49           O 0
ATOM   1281  NE1 TRP A 177     -14.483  17.972 -18.227  1.00 18.18           N 0
ATOM   1390   CB ARG A 193      -9.902  13.203 -17.893  1.00 32.68           C 0
ATOM   1284  CZ2 TRP A 177     -13.874  20.236 -19.118  1.00 16.76           C 0
ATOM   1392   CD ARG A 193      -8.948  12.103 -19.961  1.00 34.21           C 0
ATOM   3367    C GLU B  51     -14.310  17.749 -23.677  1.00 47.12           C 0
ATOM   3369   CB GLU B  51     -15.585  18.058 -21.561  1.00 52.34           C 0
ATOM   3374    N GLY B  52     -13.476  18.652 -24.184  1.00 44.31           N 0
ATOM   1418   NE ARG A 196      -6.383  13.964 -15.654  1.00 42.54           N 0
ATOM   1417   CD ARG A 196      -5.862  15.079 -14.867  1.00 39.58           C 0
ATOM   1420  NH1 ARG A 196      -4.455  13.704 -16.883  1.00 42.68           N 0
ATOM   1419   CZ ARG A 196      -5.696  13.329 -16.601  1.00 43.17           C 0
ATOM   3386  NE1 TRP B  53      -6.757  17.739 -26.364  1.00 28.44           N 0
ATOM   1393   NE ARG A 193      -7.956  11.220 -20.587  1.00 31.92           N 0
ATOM   5303  OE2 GLU B 315      -4.060  12.535 -25.951  1.00  9.80           O 0
ATOM   1421  NH2 ARG A 196      -6.246  12.317 -17.266  1.00 42.02           N 0
ATOM   1391   CG ARG A 193      -8.830  12.238 -18.430  1.00 33.29           C 0
ATOM   1387   CA ARG A 193      -9.663  13.759 -16.479  1.00 30.91           C 0
TER
END
