#!/usr/bin/perl
use strict;
use warnings;

my $file = $ARGV[0] || "myfile.xls";

open FH, $file or die $!;

my $title = <FH>;

my @fields = split( /,/, $title );

while (<FH>) {

    my @values = split(/,/);

    for ( my $i = 0 ; $i < $#values ; $i++ ) {

        $fields[$i] =~ s/^ *| *$//g;
        $values[$i] =~ s/^ *| *$//g;
        print $fields[$i], ": ", $values[$i];
        print "\n";
    }
    print "\n";

}

close(FH)
