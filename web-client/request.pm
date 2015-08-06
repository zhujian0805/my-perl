package request;
use strict;
use warnings;
use vars qw(@ISA);
use LWP;

@ISA = qw(LWP::UserAgent);

sub new {
    my $self = LWP::UserAgent::new(@_);

    my $class   = shift;
    my $options = {@_};

    foreach my $option ( keys %$options ) {
        $self->{$option} = $options->{$option};
    }

    bless $self;
    return $self;
}

sub get_basic_credentials {
    my $self = shift;
    return ( $self->{'user'}, $self->{'password'} );
}

