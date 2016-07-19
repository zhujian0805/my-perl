#!/usr/bin/perl -w
use strict;
use LWP 5.64;

my $browser = LWP::UserAgent->new;
my $url = 'http://10.24.0.242:8085';
my $response = $browser->get($url);

die "Error:\n ", $response->header('WWW-Authenticate') || 
    "\nError accessing: \n", $response->status_line,
    "\n at $url\n Aborting\n" unless $response->is_success;
