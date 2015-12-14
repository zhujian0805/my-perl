#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: closure.pl
#
#        USAGE: ./closure.pl
#
#  DESCRIPTION: test
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2014年08月20日 14时10分44秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

sub make_saying {
    my $salute  = shift;
    my $newfunc = sub {
        my $target = shift;
        print "$salute, $target!\n";
    };

    # Return a closure
    return $newfunc;

}

# Create a closure
my $f = make_saying("Howdy");

# Create another closure
my $g = make_saying("Greetings");

# Time passes...
$f->("world");
$g->("earthlings");
