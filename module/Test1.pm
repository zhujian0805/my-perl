#Overriding WWW::Mechanize
use WWW::Mechanize;
package Test1;
 
use vars qw(@ISA);
@ISA = qw(WWW::Mechanize);
our  $package_var1 = 100;
my $literal_var1 = 200;
 
my ( $username, $password ) = ( undef, undef );
 
# method to set username and password for authentication
sub set_vars {
  shift;
  ( $username, $password ) = @_;
}
 
# this routine gets called when your browser
#   would otherwise be asked to provide a
#   username and password
sub show_vars {
  shift;
  #my ($self, $realm, $uri) = @_;
  #my $self = shift;
  #print( STDERR "  - providing auth to realm \"$realm\"\n" );
  print( $username, $password , "\n");
  #return( 'guest', 'guest' );
}

1;
