#!/usr/bin/perl 

use strict;
use warnings;
use Employee;
use Data::Dumper;

my $me = new Employee('ABC', 99, 170, 66);

print Dumper $me;
