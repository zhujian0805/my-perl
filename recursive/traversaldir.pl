#!/usr/bin/perl 
use strict;
use warnings;
use File::Basename;
use Cwd;
use Data::Dumper;

sub find_dir {
    my  ($par1) = shift;
    my $subname = (caller(0))[3];

    return if($par1 =~ /^\.|\.\.$/);
    if(! -d $par1){
        print $par1,"\n";
        return;
    }

    my @files = glob("$par1/*");
   
    foreach my $file ( @files ) {
        if ( -d $file ) {
            &find_dir($file);
        }else{
            print $file,"\n";
        }
    }

} # ----------  end of subroutine find_dir  ----------


&find_dir($ARGV[0]);
