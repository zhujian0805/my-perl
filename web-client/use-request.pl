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

sub Get {
    my ( $uri, $params ) = @_;

    my $req = request->new( user => 'me', password => 'changeme' );

    my $result = $req->request( POST "http://$server/$uri", $params );
    if ( not $result->is_success ) {
        print "Failed: $uri " . $result->status_line . "\n";
        exit;
    }
    my $xml = new XML::Simple();
    open TEMPFILE, ">.tempdata.xml" or die "could not open .tempdata.xml: $!";
    print TEMPFILE $result->content;
    close TEMPFILE;
    return $xml->XMLin( '.tempdata.xml', ForceArray => [b] );
}
