#!/usr/bin/perl 
#===============================================================================
#
#         FILE: find-installed-modules.pl
#
#        USAGE: ./find-installed-modules.pl  
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
#      CREATED: 2014年11月07日 16时46分38秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;


use ExtUtils::Installed;
my $inst    = ExtUtils::Installed->new();
my @modules = $inst->modules();

print Dumper \@modules;

#print files belong to the module

my @mod_files = $inst->files("HTTP::Cookies");

print Dumper \@mod_files;
