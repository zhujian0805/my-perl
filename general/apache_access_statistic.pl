#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my %hash;
while (<ARGV>) {
    my ($item) = $_ =~ /.*(\[.*\]).*/;
    $item =~ s/\[//g;
    $item =~ s/:.*$//g;
    my ( $date, $mon, $year ) = $item =~ /(.*?)\/(.*)\/(.*)/g;
    $hash{$year}{$mon}{$date}++;
}

foreach my $y ( keys %hash ) {
    foreach my $m ( keys %{ $hash{$y} } ) {
        foreach my $d ( sort keys %{ $hash{$y}{$m} } ) {
            print $y. " " . $m . " " . $d . ":", " ", $hash{$y}{$m}{$d};
            print "\n";
        }
    }
}

