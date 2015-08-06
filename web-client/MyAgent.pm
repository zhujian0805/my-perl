#Overriding LWP::UserAgent
use LWP::UserAgent;
package MyAgent;
 
use vars qw(@ISA);
@ISA = qw(LWP::UserAgent);
 
my ( $username, $password ) = ( undef, undef );
 
# method to set username and password for authentication
sub set_credentials {
  shift;
  ( $username, $password ) = @_;
}
 
# this routine gets called when your browser
#   would otherwise be asked to provide a
#   username and password
sub get_basic_credentials {
    shift;
    return( $username, $password );
}


1;
