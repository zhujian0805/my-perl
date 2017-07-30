#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: ftp-test.pl
#
#        USAGE: ./ftp-test.pl  
#
#  DESCRIPTION: test ftp
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (), zhujian0805@gmail.com
# ORGANIZATION: ZJ
#      VERSION: 1.0
#      CREATED: 07/30/2017 07:48:41 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Net::FTP;

my $ftp = Net::FTP->new("localhost") or die "Cannot connect to some.host.name: $@";

$ftp->login("jzhu", "123456");

foreach my $dir ( $ftp->ls("/tmp") ) {
    print $dir, "\n";
}

$ftp->get("/tmp/testing-ftp", "/tmp/testing-ftp-got");
