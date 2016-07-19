#!/usr/bin/perl 

use strict;
use warnings;
use Digest::MD5 qw/md5_hex/;


foreach my $i ( 0 .. 999  ) {
    
    foreach my $j ( 0 .. 9999   ) {

        my $str = $i . '-' . $j;
        my $result = md5_hex($str);

        print "$i-$j --> " , $result, "\n";

        if ( $result =~ /$ARGV[0]/i  ) {
            exit;
        }

    }

}
