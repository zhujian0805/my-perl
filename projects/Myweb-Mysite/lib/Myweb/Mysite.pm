package Myweb::Mysite;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/fuck/:name' => sub {
    return "Why, hello there " . params->{name};
};


true;
