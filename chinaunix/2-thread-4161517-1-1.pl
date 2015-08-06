#!/usr/bin/perl 
use strict;
use warnings;
use utf8;
use Data::Dumper;
use v5.10;

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
            analyse_contig_tree_recursively( $it, $TAXA_TREE->{$_} );
            next;
        }

        if ( $i[0] - 1 == $j[1] ) {
            $TAXA_TREE->{$_}{$it} = undef;
            analyse_contig_tree_recursively( $it, $TAXA_TREE->{$_} );
            next;
        }
    }
}

sub traverse (&$@) {
    my ( $do_it, $data, @path ) = @_;

    # iterate
    foreach my $key ( sort keys %$data ) {

        # handle sub-tree
        if ( ref( $data->{$key} ) eq 'HASH' ) {
            &traverse( $do_it, $data->{$key}, @path, $key );
            next;
        }

        # handle leave
        if ( defined( $data->{$key} ) ) {
            if ( $data->{$key} =~ /100$/ ) {
                $do_it->( $data->{$key}, @path, $key );
            }
            else {
                next;
            }
        }
        else {
            if ( $key =~ /100$/ ) {
                $do_it->( @path, $key );
            }
            else {
                next;
            }
        }
    }
}

foreach my $a ( sort keys %hash0 ) {
    foreach my $b ( sort keys %{ $hash0{$a} } ) {
        &analyse_contig_tree_recursively( $b, $hash{$a} );
    }
}

#print Dumper \%hash0;

traverse { 
    my ($it, @rest) = @_;    
    my @col3;
    foreach(@rest){
        push @col3, keys $hash0{$it}{$_};
    }
    say $it, " @rest", " @col3";
} \%hash;

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
