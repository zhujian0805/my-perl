#!/usr/bin/perl
use Data::Dumper;

my %locations;
my $location;
my $int;
my $addr;
while(<DATA>){
  if(/location: "(.*)"/){
    $location = $1;
  }

  if(/name: "(.*)"/){
    $int = $1;
  }
  if(/address: "(.*)"/){
    $addr = $1;
    $locations{$location}{$int} = $addr;
  }
  
}

print Dumper \%locations;

__DATA__
location {
  location: "hostname"
  interface {
    name: "eth0"
    address: "10.16.96.11"
  }
  interface {
    name: "ilo"
    address: "10.16.112.111"
  }
}

location {
  location: "hostname1"
  interface {
    name: "eth0"
    address: "10.16.96.11"
  }
  interface {
    name: "ilo"
    address: "10.16.112.111"
  }
}
