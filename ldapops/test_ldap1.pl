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
#       AUTHOR: 
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
print "\n";
ReadMode 'restore';

my $ldap = Net::LDAP->new('ldapserver', timeout => 5 ) or die "$@";
 
# bind to a directory with dn and password
my $mesg = $ldap->bind( 'user=jzhu, ou=users, dc=sample, dc=net', password => $password);
 
$mesg = $ldap->search( # perform a search
                       base   => "ou=locations, dc=sample, dc=net",
                       scope  => "sub",
                       filter => "(location=hostname)"
                     );
 
$mesg->code && die $mesg->error;
 
my $max = $mesg->count;

for( my $i=0; $i< $max; $i++){
    my $entry = $mesg->entry($i);
    if($entry->get_value("location") =~ "hostname"){
        print Dumper $entry->get_value("interface");
        print "\n";
    }
}

