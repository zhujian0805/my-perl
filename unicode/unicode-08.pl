#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

my $out = "你好";
my $in;

open( F, ">:utf8", "data.utf" );
print F $out;
close(F);

open( F, "<:utf8", "data.utf" );
$in = <F>;
close(F);

print $in;
