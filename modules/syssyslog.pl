#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: syssyslog.pl
#
#        USAGE: ./syssyslog.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 07/15/2015 01:29:05 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use strict;
use warnings;
use Sys::Syslog;
use Sys::Syslog qw(switchtandard :macros);
use File::Basename;


openlog(basename($0), "ndelaypublicid", "kern");

open(FH, "/home/jzhu/2012122609_bgid.log");
while(<FH>){
    syslog("info", $_);
  }
  close(FH);
  closelog();
}
