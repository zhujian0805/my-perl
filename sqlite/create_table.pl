#!/usr/bin/perl 
#===============================================================================
#
#         FILE: create_table.pl
#
#        USAGE: ./create_table.pl  
#
#  DESCRIPTION: i
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), jzhu@jz.com
# ORGANIZATION:  CN
#      VERSION: 1.0
#      CREATED: 05/30/2014 05:55:21 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use DBI;
use strict;

my $driver   = "SQLite";
my $database = "test.db";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 })
                      or die $DBI::errstr;
print "Opened database successfully\n";

my $stmt = qq(
create table trills (
    time  integer    not null,
        user  varchar(12)  not null,
            trill varchar(140) not null
        );
       );
my $rv = $dbh->do($stmt);
if($rv < 0){
   print $DBI::errstr;
} else {
   print "Table created successfully\n";
}
$dbh->disconnect();
