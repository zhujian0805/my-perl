#!/usr/bin/perl
#
# import LOCK_* and SEEK_END constants
use Fcntl qw(:flock SEEK_END);

sub lock {
    my ($fh) = @_;
    flock( $fh, LOCK_EX ) or die "Cannot lock mailbox - $!\n";
}

sub unlock {
    my ($fh) = @_;
    flock( $fh, LOCK_UN ) or die "Cannot unlock mailbox - $!\n";
}

open( my $mbox, ">>", "/tmp/testfile" ) or die "Can't open mailbox: $!";

my $msg = "testing";

lock($mbox);

while(1){
  print $mbox $msg, "\n\n";
}

unlock($mbox);

close $mbox;
