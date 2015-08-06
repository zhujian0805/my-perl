#!/usr/bin/perl
package Employee;
use Person;
use strict;
use warnings;

our @ISA = qw(Person);

sub new
{
    my $class = shift;
    my $name = shift // "James Zhu";
    my $age = shift // 99;
    my $self = $class->SUPER::new( $name, $age );
    $self->{hight} = shift // 170;
    $self->{weight} = shift // 65;
    bless $self, $class;
    return $self;
}

1;
