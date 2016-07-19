#!/usr/bin/perl
use strict;
use warnings;
use Socket;
require 'sys/ioctl.ph';

sub get_interface_address
{
    my ($iface) = @_;
    my $socket;
    socket($socket, PF_INET, SOCK_STREAM, (getprotobyname('tcp'))[2]) || die "unable to
create a socket: $!\n";
    my $buf = pack('a256', $iface);
    if (ioctl($socket, SIOCGIFADDR(), $buf) && (my @address = unpack('x20 C4', $buf)))
    {
        return join('.', @address);
    }
    return undef;
}

print get_interface_address('eth0');
print "\n";
print get_interface_address('eth0:0');
print "\n";
