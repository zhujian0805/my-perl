#!/usr/bin/perl 
#===============================================================================
#
#         FILE: test-class1.pl
#
#        USAGE: ./test-class1.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: James Zhu (N/A), zhujian0805@gmail.com
# ORGANIZATION: JZ
#      VERSION: 1.0
#      CREATED: 2014年11月11日 14时19分03秒
#     REVISION: ---
#===============================================================================

#use strict;
#use warnings;
#use utf8;
use v6;

class Task {
    has      &!callback;
    has Task @!dependencies;
    has Bool $.done;

    method new(&callback, *@dependencies) {
        return self.bless(:&callback, :@dependencies);
    }

    submethod BUILD(:&!callback, :@!dependencies) { }

    method add-dependency(Task $dependency) {
        push @!dependencies, $dependency;
    }

    method perform() {
        unless $!done {
            .perform() for @!dependencies;
            &!callback();
            $!done = True;
        }
    }
}

my $eat =
    Task.new({ say 'eating dinner. NOM!' },
        Task.new({ say 'making dinner' },
            Task.new({ say 'buying food' },
                Task.new({ say 'making some money' }),
                Task.new({ say 'going to the store' })
            ),
            Task.new({ say 'cleaning kitchen' })
        )
    );

$eat.perform();
