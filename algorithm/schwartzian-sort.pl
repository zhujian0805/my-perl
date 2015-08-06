#!/usr/bin/perl 
use strict;
use warnings;
use utf8;
use Data::Dumper;

my %hash;

while (<DATA>) {

    my @array = split;
    ${ $hash{ $array[0] }{middle} }{ $array[1] } = $array[2];

}

print Dumper \%hash;

foreach my $col1 ( sort keys %hash ) {

    my @sorted =
      map  { $_->[0] }
      sort { $a->[1] <=> $b->[1] }
      map  { [ $_, ( split(/-/) )[0] ] } ( keys $hash{$col1}{middle} );

    print Dumper \@sorted;

}

# sort the following data by the first number of the second column numericallyascending
__DATA__
d   1-30      A
d   1-30      A
d   1-30      A
a   1-30      A
a   9-30      B
a   31-70    D
a   31-100  F
a   71-100  U
b   1-50      J
b   1-90      K
b   51-100   JK
c   1-20      ll
c   21-99     L
