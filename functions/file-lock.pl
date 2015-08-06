#!/usr/bin/perl
#
# import LOCK_* and SEEK_END constants
# run this script in one terminal
# THEN run it at the same time in another terminal, you will see it cannot lock it because
# the file is already locked
use Fcntl qw(:flock SEEK_END);

sub lock {
    my ($fh) = @_;
    flock( $fh, LOCK_EX|LOCK_NB ) or die "Cannot lock mailbox - $!\n";
}

sub unlock {
    my ($fh) = @_;
    flock( $fh, LOCK_UN ) or die "Cannot unlock mailbox - $!\n";
}

open( my $mbox, ">", "/tmp/testfile" ) or die "Can't open mailbox: $!";

my $msg = "testing";

lock($mbox);

while(1){
  print $mbox $msg, "\n\n";
}

unlock($mbox);

close $mbox;
