#!/usr/bin/perl -w
use strict;
use LWP 5.64;

my $browser = LWP::UserAgent->new;
my $url = 'http://www.baidu.com';
my $response = $browser->get($url);

die "Error: ", $response->header('WWW-Authenticate') || 
    'Error accessing', "\n ", $response->status_line,
    "\n at $url\n Aborting" unless $response->is_success;
