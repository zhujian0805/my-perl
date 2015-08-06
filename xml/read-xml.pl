#!/usr/bin/perl 
#===============================================================================
#
#         FILE: read-xml.pl
#
#        USAGE: ./read-xml.pl  
#
#  DESCRIPTION: G
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), jzhu@jz.com
# ORGANIZATION:  CN
#      VERSION: 1.0
#      CREATED: 02/24/2014 01:13:25 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use Data::Dumper;


use XML::Simple qw(:strict);

my $ref = XMLin("blades.xml", ForceArray => 1, KeyAttr => 1);

print Dumper $ref;
