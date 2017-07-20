#!/usr/bin/perl 
#===============================================================================
#
#         FILE: use-My.pl
#
#        USAGE: ./use-My.pl  
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
#      CREATED: 2014年10月31日 09时15分35秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use MyMech;
use Data::Dumper;

my $mech = MyMech->new();

my $url = 'https://website-for-login/logon';
$mech->set_credentials( "jzhu", 'changeme' );
$mech->get( $url );

$url = 'https://website-for-content/';
$mech->get( $url );

print( "status is: ", $mech->status . "\n" );
print( $mech->success );

print Dumper $mech->response;
