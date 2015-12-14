#!/usr/bin/perl 
#===============================================================================
#
#         FILE: test-Test.pl
#
#        USAGE: ./test-Test.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2014年10月31日 11时36分50秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Test1;
use Data::Dumper;

Test1->set_vars('abc', 'dec');
Test1->show_vars();
print $Test1::package_var1, "\n";
print $Test1::literal_var1, "\n";
#print $literal_var1, "\n";

print Dumper %main::;
print Dumper %package::;
