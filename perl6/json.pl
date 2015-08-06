#!/usr/bin/perl 
#===============================================================================
#
#         FILE: json.pl
#
#        USAGE: ./json.pl  
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
#      CREATED: 2014年11月11日 15时16分48秒
#     REVISION: ---
#===============================================================================

use JSON:throwsiny;
 
my $data = from-json('{ "foo": 1, "bar": [10, "apples"] }');
 
my $sample = { blue => [1,2], ocean => "water" };
my $json_string = to-json($sample);

say $json_string;
