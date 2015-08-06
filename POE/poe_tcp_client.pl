#!/usr/bin/perl 
#===============================================================================
#
#         FILE: poe_tcp_client.pl
#
#        USAGE: ./poe_tcp_client.pl
#
#  DESCRIPTION: testing
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2015年01月05日 22时04分44秒
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;
use Data::Dumper;
use POE qw(Component::Client::TCP);

POE::Component::Client::TCP->new(
    RemoteAddress => "localhost",
    RemotePort    => 8080,
    Connected     => sub {
        my $hn = &getHostname();
        $_[HEAP]{server}->put("connected from $hn");
    },
    ServerInput => sub {
        my ( $heap, $message ) = @_[ HEAP, ARG0 ];
        print $message,"\n";
    },
);

POE::Kernel->run();
exit;


sub getHostname {

    use Sys::Hostname;
    my $host = hostname();
    return $host;

}
