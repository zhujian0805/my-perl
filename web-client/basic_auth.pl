#!/usr/bin/perl 
#===============================================================================
#
#         FILE: basic_auth.pl
#
#        USAGE: ./basic_auth.pl
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
#      CREATED: 2014年10月30日 17时05分15秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use LWP::UserAgent;
use Data::Dumper;

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

my $req = HTTP::Request->new(GET => "http://rabbitmq01.sample.net:15672/api/vhosts");
$req->authorization_basic('guest', 'guest');

print $ua->request($req)->as_string;
