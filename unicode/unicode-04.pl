#!/usr/bin/env perl 
##!/bin/env perl

# fileencoding: utf8
# termencoding: gbk

use strict;
use warnings;
use utf8;

my $str = "abcd";
my $str2 = "甲乙丙丁";

foreach ($str, $str2)
{
        if (utf8::is_utf8($_))
        {
                print "Yes\n";
        }
        else
        {
                print "No\n";
        }
}
