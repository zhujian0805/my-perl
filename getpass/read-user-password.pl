#!/usr/bin/perl 
#===============================================================================
#
#         FILE: test_ldap1.pl
#
#        USAGE: ./test_ldap1.pl  
#
#  DESCRIPTION: testing ldap
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A)
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 03/14/2014 11:40:24 AM
#     REVISION: ---
#===============================================================================
use strict;
use warnings;
use Data::Dumper;
use Net::LDAP;
use Term::ReadKey;

print "Enter your password:";
ReadMode 'noecho';
my $password = ReadLine 0;
chomp $password;
print "\n";  #<<<< Here we need print a newline because after you enter the password and hit enter it will not show newline with out this
ReadMode 'restore';

print "\nyour password:", $password, "\n";
