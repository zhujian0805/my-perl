#!/bin/env perl

# fileencoding: utf8
# termencoding: gbk

use strict;
use warnings;
use Encode;
use Encode::CN;

my $str = "中文字符串";
&testing($str);
Encode::_utf8_on($str);
&testing($str);

sub testing {
    my ($str) = @_;
    if ( Encode::is_utf8($str) ) {
        print "utf8: Yes\n";
    }
    else {
        print "utf8: No\n";
    }

    print "Length: ", length($str), "\n";
    while ( $str =~ /(.)/g ) {
        print encode( "utf8", $1 ), " ";
    }

    print "\n\n";
}
