#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $longest = "";
my @pals;

sub find_palindrome
{
    my $s = shift;
    if(length($s)==1){
        return;
    }
    if($s eq reverse($s))
    {
        if(length($s) == length($longest))
        {
            $longest = $longest . ":". $s;
        }elsif(length($s) > length($longest)){
            $longest = $s;
        }
            push @pals, $s;
    }else{
        &find_palindrome(substr($s,1,length($s)));
    }
}


    
sub find_longest_palindrome
{
    my $s = shift;
    if(length($s) == 1)
    {
        return;
    }
    &find_palindrome($s);
    &find_longest_palindrome(substr($s,0,length($s)-1));
}


if(length(@ARGV) != 1)
{
    print "Please provide a string as argument";
    exit;
}

my $s = $ARGV[0];
&find_longest_palindrome($s);
print Dumper \@pals;
print "Longgest palindrome is: " , $longest,"\n";
