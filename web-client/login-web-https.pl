#!/usr/bin/perl 
#===============================================================================
#
#         FILE: login-web.pl
#
#        USAGE: ./login-web.pl
#
#  DESCRIPTION:
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A),
# ORGANIZATION:
#      VERSION: 1.0
#      CREATED: 2014年08月03日 11时23分01秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use HTTP::Request;
use HTTP::Cookies;
use LWP::UserAgent;
use Data::Dumper;
use HTML::TreeBuilder::XPath;
use File::Temp qw/ tempfile tempdir /;

my $ua = LWP::UserAgent->new;

my $tree = HTML::TreeBuilder::XPath->new;

my $cookie_jar = HTTP::Cookies->new(
    file     => "./acookies.lwp",
    autosave => 1,
);

# Retreive the csrf token
my $LOGIN_URL = 'https://www.battlenet.com.cn/login/zh/?ref=https://www.battlenet.com.cn/account/management/&app=bam&cr=true';
my $cookies = $ua->cookie_jar($cookie_jar);
$ua->agent('Mozilla/9 [en] (Centos; Linux)');
my $res = $ua->get($LOGIN_URL);
my ($fh, $filename) = tempfile();
binmode( $fh, ":utf8" );
print $fh $res->decoded_content;
$tree->parse_file( $filename );
my @csrftokens = $tree->findvalues( '//input[@name="csrftoken"]/@value' );

# Login
$res = $ua->post(
        $LOGIN_URL,
        [
         accountName => $ARGV[0],
         password => $ARGV[1],
         csrftoken => $csrftokens[0],
        ],
);

my $ACC_MGMT_URL = 'https://www.battlenet.com.cn/account/management/';

$res = $ua->get($ACC_MGMT_URL);

($fh, $filename) = tempfile();
binmode( $fh, ":utf8" );
print $fh $res->decoded_content;

$tree->parse_file( $filename );
my @nodes = $tree->findnodes( '//p[@id="battletag-free"]' );

print Dumper \@nodes;



