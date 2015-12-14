#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
use Data::Dumper;

my %hash;

while (<DATA>) {
    my @items = ( $_ =~ /(HTTP\/\d\.\d)" .*? .*? ".*?" "(.*?) /);
    $hash{$items[0]}{count}++;
    $hash{$items[0]}{$items[1]}++;
}

print Dumper \%hash;


__DATA__
127.0.0.1 - - [01/Sep/2014:09:15:21 +0800] "GET / HTTP/1.1" 200 3594 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/36.0.1985.125 Chrome/36.0.1985.125 Safari/537.36"
127.0.0.1 - - [01/Sep/2014:09:15:22 +0800] "GET /icons/ubuntu-logo.png HTTP/1.1" 200 3688 "http://localhost/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/36.0.1985.125 Chrome/36.0.1985.125 Safari/537.36"
127.0.0.1 - - [01/Sep/2014:09:15:22 +0800] "GET /favicon.ico HTTP/1.1" 404 498 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/36.0.1985.125 Chrome/36.0.1985.125 Safari/537.36"
127.0.0.1 - - [01/Sep/2014:09:15:29 +0800] "GET / HTTP/1.1" 200 3594 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0"
127.0.0.1 - - [01/Sep/2014:09:15:29 +0800] "GET /icons/ubuntu-logo.png HTTP/1.1" 200 3688 "http://localhost/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0"
127.0.0.1 - - [01/Sep/2014:09:15:31 +0800] "GET /favicon.ico HTTP/1.1" 404 498 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0"
127.0.0.1 - - [01/Sep/2014:09:17:25 +0800] "GET / HTTP/1.1" 200 11820 "-" "Wget/1.15 (linux-gnu)"
