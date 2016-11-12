#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: scan-port.pl
#
#        USAGE: ./scan-port.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (), zhujian0805@gmail.com
# ORGANIZATION: ZJ
#      VERSION: 1.0
#      CREATED: 2016年11月12日 12时43分37秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Socket;

# initialize host and port
my $host = shift || 'localhost';
my $port = shift || 7890;
my $server = "localhost";  # Host IP running the server

# create the socket, connect to the port
socket(SOCKET,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2])
   or die "Can't create a socket $!\n";
connect( SOCKET, pack_sockaddr_in($port, inet_aton($server)))
   or die "Can't connect to port $port! \n";

my $line;
while ($line = <SOCKET>) {
        print "$line\n";
}
close SOCKET or die "close: $!";
