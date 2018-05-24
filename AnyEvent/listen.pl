#!/opt/perl/bin/perl
use strict;
use Socket;
use IO::Socket::INET;
use AnyEvent::Socket;
use AnyEvent::Handle;
 
my $cv = AnyEvent->condvar;
 
my $hdl;
 
warn "listening on port 34832...\n";
 
AnyEvent::Socket::tcp_server undef, 34832, sub {
   my ($clsock, $host, $port) = @_;
   print "Got new client connection: $host:$port\n";
 
   $hdl =
      AnyEvent::Handle->new (
         fh => $clsock,
         on_eof => sub { print "client connection $host:$port: eof\n" },
         on_error => sub { print "Client connection error: $host:$port: $!\n" }
      );
 
   $hdl->push_write ("Hello!\015\012");
 
   $hdl->push_read (line => sub {
      my (undef, $line) = @_;
      print "Yay, got line: $line\n";
      $hdl->push_write ("Bye\015\012");
      $hdl->on_drain (sub { $hdl->fh->close; undef $hdl });
   });
};
 
$cv->wait;
