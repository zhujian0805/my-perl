#!/usr/bin/perl
use strict;
use warnings;
use v5.10;
use Data::Dumper;

my %people = (
    memowe => {
        NAMES => {
            memo => { AGE => 666 },
            we   => { AGE => 667 },
        },
    },
    bladepanthera => {
        NAMES => {
            blade    => { AGE => 42 },
            panthera => { AGE => { Fuck => "you" } },
        },
    },
);

sub traverse (&$@) {
    my ( $do_it, $data, @path ) = @_;

    # iterate
    foreach my $key ( sort keys %$data ) {

        # handle sub-tree
        if ( ref( $data->{$key} ) eq 'HASH' ) {

# The magic is here, you see we added $key to the end of the argument list, So next invocation $key is added to @path for traverse
            &traverse( $do_it, $data->{$key}, @path, $key );
            next;
        }

        # handle leave
        $do_it->( $data->{$key}, @path, $key );
    }
}

# see what is passed to {}
traverse { say shift . " is in (@_)" } \%people;
#
#my @flattened_people = ();
#
#traverse {
#    my ( $thing, @path ) = @_;
#    push @flattened_people, { age => $thing, path => \@path };
#}
#\%people;
#
#print Dumper \@flattened_people;
