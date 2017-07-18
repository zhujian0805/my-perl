#!/usr/bin/perl 
#===============================================================================
#
#         FILE: use-request.pl
#
#        USAGE: ./use-request.pl
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
#      CREATED: 2014年10月31日 09时05分58秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use MyAgent;
use Data::Dumper;

my $ua = MyAgent->new();
my $req = HTTP::Request->new(GET => "https://admin.company.net/logon");
$ua->set_credentials('jzhu', 'XXXXXXXX');
my $result = $ua->request( $req );
if ( not $result->is_success ) {
    print "Failed: " . $result->status_line . "\n";
    exit;
}

print Dumper $result->{_headers}->{'set-cookie'};
