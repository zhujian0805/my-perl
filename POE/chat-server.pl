#!/usr/bin/perl
# This program is a simple chat server.  It allows multiple people to
# connect and exchange messages.  It's a very simple example, but it
# can be the basis of many multiuser things.
use warnings;
use strict;
use POE;
use POE::Component::Server::TCP;

# Create the server on port 32080, and start it running.
POE::Component::Server::TCP->new(
    Alias              => "chat_server",
    Port               => 32080,
    InlineStates       => { send => \&handle_send },
    ClientConnected    => \&client_connected,
    ClientError        => \&client_error,
    ClientDisconnected => \&client_disconnected,
    ClientInput        => \&client_input,
);
$poe_kernel->run();
exit 0;

# This is a plain Perl function (not a POE event handler) that
# broadcasts a message to all the users in the chat room.  The %users
# hash is used to track connected people.
my %users;

sub broadcast {
    my ( $sender, $message ) = @_;
    foreach my $user ( keys %users ) {
        if ( $user == $sender ) {
            $poe_kernel->post( $user => send => "You $message" );
        }
        else {
            $poe_kernel->post( $user => send => "$sender $message" );
        }
    }
}

# Handle an outgoing message by sending it to the client.
sub handle_send {
    my ( $heap, $message ) = @_[ HEAP, ARG0 ];
    $heap->{client}->put($message);
}

# Handle a connection.  Register the new user, and broadcast a message
# to whoever is already connected.
sub client_connected {
    my $session_id = $_[SESSION]->ID;
    $users{$session_id} = 1;
    broadcast( $session_id, "connected." );
}

# The client disconnected.  Remove them from the chat room and
# broadcast a message to whoever is left.
sub client_disconnected {
    my $session_id = $_[SESSION]->ID;
    delete $users{$session_id};
    broadcast( $session_id, "disconnected." );
}

# The client socket has had an error.  Remove them from the chat room
# and broadcast a message to whoever is left.
sub client_error {
    my $session_id = $_[SESSION]->ID;
    delete $users{$session_id};
    broadcast( $session_id, "disconnected." );
    $_[KERNEL]->yield("shutdown");
}

# Broadcast client input to everyone in the chat room.
sub client_input {
    my ( $kernel, $session, $input ) = @_[ KERNEL, SESSION, ARG0 ];
    my $session_id = $session->ID;
    broadcast( $session_id, "said: $input" );
}

