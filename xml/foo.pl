#!/usr/bin/perl
use XML::Simple qw(:strict);
use Data::Dumper;
 
my $config = XMLin('foo.xml', KeyAttr => ['osname'], ForceArray => [ 'server', 'address' ]);
#my $config = XMLin(undef, KeyAttr => { server => 'name' }, ForceArray => [ 'server', 'address' ]);
print Dumper($config);
