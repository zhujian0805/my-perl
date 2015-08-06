#!/usr/bin/perl 
use strict;
use warnings;
use utf8;

sub analyse_contig_tree_recursively {
    my $TAXA_TREE = shift @_;
    foreach ( keys %{$TAXA_TREE} ) {
        print "$_ \t";
        if ( ref $TAXA_TREE->{$_} eq 'HASH' ) {
            analyse_contig_tree_recursively( $TAXA_TREE->{$_} );
        }
        print "\n";
    }
}

my %hash = ( a => 1, b => 2, ( c => 4, d => 5 ) );

&analyse_contig_tree_recursively( \%hash );
