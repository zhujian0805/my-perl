#!/usr/bin/perl
use warnings;
use strict;
use POSIX;
use IO::Socket;
use IO::Select;
use Tie::RefHash;
### Create the server socket.
my $server = IO::Socket::INET->new(
  LocalPort => 12345,
  Listen    => 10,
) or die "can't make server socket: $@\n";
$server->blocking(0);
### Set up structures to track input and output data.
my %inbuffer  = ();
my %outbuffer = ();
my %ready     = ();
tie %ready, "Tie::RefHash";
### The select loop itself.
my $select = IO::Select->new($server);

while (1) {

  # Process sockets that are ready for reading.
  foreach my $client ($select->can_read(1)) {
    handle_read($client);
  }

  # Process any complete requests.  Echo the data back to the client,
  # by putting the ready lines into the client's output buffer.
  foreach my $client (keys %ready) {
    foreach my $request (@{$ready{$client}}) {
      print "Got request: $request";
      $outbuffer{$client} .= $request;
    }
    delete $ready{$client};
  }

  # Process sockets that are ready for writing.
  foreach my $client ($select->can_write(1)) {
    handle_write($client);
  }
}
exit;
### Handle a socket that's ready to be read from.
sub handle_read {
  my $client = shift;

  # If it's the server socket, accept a new client connection.
  if ($client == $server) {
    my $new_client = $server->accept();
    $new_client->blocking(0);
    $select->add($new_client);
    return;
  }

  # Read from an established client socket.
  my $data = "";
  my $rv = $client->recv($data, POSIX::BUFSIZ, 0);

  # Handle socket errors.
  unless (defined($rv) and length($data)) {
    handle_error($client);
    return;
  }

  # Successful read.  Buffer the data we got, and parse it into lines.
  # Place the lines into %ready, where they will be processed later.
  $inbuffer{$client} .= $data;
  while ($inbuffer{$client} =~ s/(.*\n)//) {
    push @{$ready{$client}}, $1;
  }
}
### Handle a socket that's ready to be written to.
sub handle_write {
  my $client = shift;

  # Skip this client if there's nothing to write.
  return unless exists $outbuffer{$client};

  # Attempt to write pending data to the client.
  my $rv = $client->send($outbuffer{$client}, 0);
  unless (defined $rv) {
    warn "I was told I could write, but I can't.\n";
    return;
  }

  # Successful write.  Remove what was sent from the output buffer.
  if ( $rv == length($outbuffer{$client})
    or $! == POSIX::EWOULDBLOCK) {
    substr($outbuffer{$client}, 0, $rv) = "";
    delete $outbuffer{$client} unless length $outbuffer{$client};
    return;
  }

  # Otherwise there was an error.
  handle_error($client);
}
### Handle client errors.  Clean up after the dead socket.
sub handle_error {
  my $client = shift;
  delete $inbuffer{$client};
  delete $outbuffer{$client};
  delete $ready{$client};
  $select->remove($client);
  close $client;
}
