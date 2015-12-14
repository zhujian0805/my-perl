#!/usr/bin/perl
package Person;
use strict;
use warnings;

sub new
{

    my $class = shift;
    my $self = {
        _name => shift // "James Zhu",
        _age  => shift // 33,
    };
    bless $self, $class;
    return $self;
}


1;
