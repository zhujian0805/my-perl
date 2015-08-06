#!/usr/bin/perl 
use strict;
use warnings;
use utf8;
use Data::Dumper;

my %hash;
my %hash0;

while (<DATA>) {

    my @array = split;

    if ( $array[1] =~ /^1/ ) {
        $hash{ $array[0] }{ $array[1] } = undef;
    }

    $hash0{ $array[0] }{ $array[1] }{ $array[2] } = undef;

}

sub analyse_contig_tree_recursively {
    my $it        = shift;
    my $TAXA_TREE = shift;
    foreach ( sort keys %{$TAXA_TREE} ) {

        my @i = split( /-/, $it );
        my @j = split( /-/, $_ );

        if ( ref $TAXA_TREE->{$_} eq 'HASH' ) {
            if ( $i[0] - 1 == $j[1] ) {
                $TAXA_TREE->{$_}{$it} = undef;
                analyse_contig_tree_recursively( $it, $TAXA_TREE->{$_} );
            }
            else {
                analyse_contig_tree_recursively( $it, $TAXA_TREE->{$_} );
            }
        }

        if ( $i[0] - 1 == $j[1] ) {
            $TAXA_TREE->{$_}{$it} = undef;
            analyse_contig_tree_recursively( $it, $TAXA_TREE->{$_} );
        }
        else {
            analyse_contig_tree_recursively( $it, $TAXA_TREE->{$_} );
        }
    }
}

sub walk_tree{

    my $TAXA_TREE = shift @_;
    foreach ( keys %{$TAXA_TREE} ) {
        if ( not defined $TAXA_TREE->{$_} ) {
            print "$_ \t";;
            return;
        }else{
            walk_tree( $TAXA_TREE->{$_} );

        }
    }
}


foreach my $a ( sort keys %hash0 ) {
    foreach my $b ( sort keys %{ $hash0{$a} } ) {
        &analyse_contig_tree_recursively( $b, $hash{$a} );
    }
}

print Dumper \%hash;

&walk_tree(\%hash);

__DATA__
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
