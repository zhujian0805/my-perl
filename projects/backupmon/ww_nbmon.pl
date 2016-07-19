#!/usr/bin/perl
################################################################################
################################################################################

use strict;
use Getopt::Long;
use POSIX qw(strftime);
use FindBin qw($RealBin);
use Fcntl qw(:DEFAULT :flock);
use Data::Dumper;

# load these modules only if we're running on windows
require Win32::Registry if ( $^O =~ m/win/i );

#####Golbal Variables######

my $installdir;
my $bindir;
my $admincmd_dir;
my $UN_logfile;

if ( $^O =~ /MSWin/i ) {

    #For Windows
    my $p = "SOFTWARE\\VERITAS\\Netbackup\\CurrentVersion";
    my $CurrVer;
    my %vals;
    my $k;
    $main::HKEY_LOCAL_MACHINE->Open( $p, $CurrVer ) || die "Open: $!";
    $CurrVer->GetValues( \%vals );    # get sub keys and value -hash ref
    foreach $k ( keys %vals ) {
        my $key = $vals{$k};
        $installdir = "$$key[2]" if ( $$key[0] eq "INSTALLDIR" );
    }
    $bindir       = "$installdir/netbackup/bin/";
    $admincmd_dir = "$installdir/netbackup/bin/admincmd/";

    $bindir       = "\"$bindir\""       if $bindir       =~ /\s/;
    $admincmd_dir = "\"$admincmd_dir\"" if $admincmd_dir =~ /\s/;
}
else {
    #For UNIX
    $installdir   = "/usr/openv/";
    $bindir       = $installdir . "netbackup/bin/";
    $admincmd_dir = $installdir . "netbackup/bin/admincmd/";

    my $logdir = "/var/opt/OV/backupmon/log/";
    if ( !-d $logdir ) {
        mkdir $logdir;
    }
    $UN_logfile = $logdir . "netbkp_mon.log";

}
our @time_range = &get_time();
our $end_time   = $time_range[0];
our $start_time = $time_range[1];

############################################################
# chk_nbu_status
#
# Inputs:  none
#
# Returns:  $count - no of NBU processes running
#
# Algorithm: Check no of NBU processes running from bpps output
#
#############################################################

sub chk_nbu_status {
    my $cmd   = $bindir . "bpps";
    my $count = "0";
    open( BPSTATUS, "$cmd |" );
    while (<BPSTATUS>) {
        if ( ( $_ =~ /bpdbm/ ) || ( $_ =~ /bprd/ ) || ( $_ =~ /bpjobd/ ) ) {
            $count = $count + 1;
        }
    }
    return $count;
}

############################################################
# get_time
#
# Inputs:  none
#
# Returns:
# $start_day(system date - 10 min) ,$start time( system time - 10 min), $end_day (system date), $end_time(system time)
#
# Algorithm:
# Checks current system time,date and subtracts 10 min from it to get values for time and date to use in bperror command
#
#############################################################

sub get_time {
    my $time = time();
    my $end_time = strftime "%m/%d/%Y %H:%M:%S", localtime($time);
    $time -= 10 * 60;
    my $start_time = strftime "%m/%d/%Y %H:%M:%S", localtime($time);

    return ( $end_time, $start_time );
}

############################################################
# backup_get_jobids
#
# Inputs: bpdbjobs command output
#
# Returns:  none
#
# Algorithm: Get Backup jobid nos in a file from bpdbjobs command output which were active in last 10 min
#
#############################################################

sub backup_get_jobids {
    my @jobs;
    my ( $end_time, $start_time ) = get_time;
    my $cmd      = $admincmd_dir . "bpdbjobs -gdm";
    my $cur_time = time();
    open( CMD, "$cmd |" );
    while (<CMD>) {
        my @data;
        my $jobid;
        my $jobtype;
        @data = split( /,/, $_ );
        my $period = $cur_time - $data[10];
        $jobtype = $data[1]
          ; # jobtype status code - (0=backup, 1=archive, 2=restore, 3=verify, 4=duplication, 5=import, 6=dbbackup, 7=vault)
        if ( $jobtype == 0 && $period < 1800 ) {
            $jobid = $data[0];
            my $output = $admincmd_dir
              . "bperror -jobid $jobid -d $start_time -e $end_time";
            my @output = `$output` if ( length($jobid) > "0" );
            my $nums = scalar(@output);
            push( @jobs, $jobid ) if ( $nums > "0" );
        }
    }
    close(CMD);
    return @jobs;
}

############################################################
# backup start
#
# Inputs: $job - from $jobid_store
#
# Returns:  none
#
# Algorithm:
#
# Check bperror output for jobid and if specific string is found write it to log file
#
#############################################################
sub backup_start {
    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -columns 300";

    open( BPSTART, "$cmd |" );
    while ( readline *BPSTART ) {
        if ( $_ =~ /(starting|started) backup job/ ) {
            $_ =~ tr/ / /s;
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Backup has started" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile" );
                print LOGFILE "JOBID:$jobid $_\n";
                close(LOGFILE);
            }
        }
    }
    close(BPSTART);
}

############################################################
# backup_completed
#
# Inputs: $job - from $jobid_store
#
# Returns:  none
#
# Algorithm: Check bperror output for jobid and if specific error code is found write it to log file
#
#
#############################################################

sub backup_completed {
    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat";

    open( BPCOMP, "$cmd |" );
    my @data = <BPCOMP>;
    chomp $data[1];
    $data[1] =~ s/^ *//;
    $data[1] =~ tr/ / /s;
    my @bkpcomp = split( / /, $data[1] );
    if ( $bkpcomp[0] == 0 ) {
        if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Backup is successfully completed" /SO "Netbackup_Monitoring"`;
        }
        else {
            open( LOGFILE, "+>> $logfile" );
            print LOGFILE "Backup Completed with JOBID:$jobid $data[1]\n";
            close(LOGFILE);
        }
    }
    close(BPCOMP);
}

############################################################
# backup_failed
#
# Inputs: $job - from $jobid_store
#
# Returns:  none
#
# Algorithm: Check bperror output for jobid and if specific error code is found write it to log file
#
#############################################################

sub backup_failed {

    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat -columns 300";

    open( BPFAILED, "$cmd |" );
    my @data = <BPFAILED>;
    chomp $data[1];
    $data[1] =~ s/^ *//;
    $data[1] =~ tr/ / /s;
    my @bpfailed = split( / /, $data[1] );
    if ( ( $bpfailed[0] != 150 && $bpfailed[0] != 0 ) ) {
        if ( $^O =~ /MSWin/i ) {
`eventcreate /T ERROR /ID 1000 /L APPLICATION /D "JOBID:$jobid Backup failed with error code $bpfailed[0]" /SO "Netbackup_Monitoring"`;
        }
        else {
            open( LOGFILE, "+>> $logfile" );
            print LOGFILE "Backup Failed with JOBID:$jobid $data[1]\n";
            close(LOGFILE);
        }
    }
    close(BPFAILED);
}

############################################################
# backup_aborted
#
# Inputs: $job - from $jobid_store
#
# Returns:   none
#
# Algorithm: Check bperror output for jobid and if specific error code is found write it to log file
#
#############################################################

sub backup_aborted {

    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat -columns 300";

    open( BPABORT, "$cmd |" );
    my @data = <BPABORT>;
    chomp $data[1];
    $data[1] =~ s/^ *//;
    $data[1] =~ tr/ / /s;
    my @bpabort = split( / /, $data[1] );
    if ( $bpabort[0] == 150 ) {
        if ( $^O =~ /MSWin/i ) {
`eventcreate /T ERROR /ID 1000 /L APPLICATION /D "JOBID:$jobid Backup Aborted with error code $bpabort[0]" /SO "Netbackup_Monitoring"`;
        }
        else {
            open( LOGFILE, "+>> $logfile" );
            print LOGFILE "Backup Aborted with JOBID:$jobid $data[1]\n";
            close(LOGFILE);
        }
    }
    close(BPABORT);
}

############################################################
# backup_queue
#
# Inputs: $job - from $jobid_store
#
# Returns:  none
#
# Algorithm: Check bperror output for jobid and if specific string is found write it to log file
#
#############################################################

sub backup_queue {
    my $logfile  = $UN_logfile;
    my $cur_time = time();
    my $cmd      = $admincmd_dir . "bpdbjobs -gdm";

    open( BPQUEUE, "$cmd |" );
    while (<BPQUEUE>) {
        my @data     = split( /,/, $_ );
        my $period   = $cur_time - $data[8];
        my $jobstate = $data[2];
        my $jobid;
        if ( $jobstate == 0 && $period < 3600 ) {
            $jobid = $data[0];
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T WARNING /ID 1000 /L APPLICATION /D "JOBID:$jobid Backup has queued" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile" );
                print LOGFILE "Backup Queued with JOBID:$jobid\n";
                close(LOGFILE);
            }
        }
    }

    close(BPQUEUE);
}

############################################################
# catalog_get_jobids
#
# Inputs: none
#
# Returns:  @jobs - Active jobs in last 10 min
#
# Algorithm: Get Catalog backup jobids in a file from bpdbjobs command output which were active in last 10 min
#
#############################################################
sub catalog_get_jobids {
    my @jobs;
    my ( $end_time, $start_time ) = get_time;
    my $cmd      = $admincmd_dir . "bpdbjobs -gdm";
    my $cur_time = time();
    open( CMD, "$cmd |" );
    while (<CMD>) {
        my @data;
        my $jobid;
        my $jobtype;
        @data = split( /,/, $_ );
        my $period = $cur_time - $data[10];
        $jobtype = $data[1]
          ; # jobtype status code - (0=backup, 1=archive, 2=restore, 3=verify, 4=duplication, 5=import, 6=dbbackup, 7=vault)
        if ( $jobtype == 6 && $period < 1800 ) {
            $jobid = $data[0];
            my $output = $admincmd_dir
              . "bperror -jobid $jobid -d $start_time -e $end_time";
            my @output = `$output` if ( length($jobid) > "0" );
            my $nums = scalar(@output);
            push( @jobs, $jobid ) if ( $nums > "0" );
        }
    }
    close(CMD);
    return @jobs;
}
######################################################
# catalog_bkp_failed
#
# Inputs: $job - from $jobid_store
#
# Returns: none
#
# Algorithm: Read the $jobid_store and for each jobid check the bperror command output,
#            whether it has failed with specific error code(120,121,253,302) and if found wtite the info to log file
#
#####################################################

sub catalog_bkp_failed {
    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat -columns 300";

    open( CATFAILED, "$cmd |" );
    my @data = <CATFAILED>;
    chomp $data[1];
    $data[1] =~ s/^ *//;
    $data[1] =~ tr/ / /s;
    my @errorcode = split( / /, $data[1] );
    if (   ( $errorcode[0] == "120" )
        || ( $errorcode[0] == "129" )
        || ( $errorcode[0] == "253" )
        || ( $errorcode[0] == "302" ) )
    {

        if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Catalog Backup Failed with $errorcode[0]" /SO "Netbackup_Monitoring"`;
        }
        else {
            open( LOGFILE, "+>> $logfile" );
            print LOGFILE "Catalog Backup Failed with $jobid $data[1]\n";
            close(LOGFILE);
        }
    }
    close(CATFAILED);
}

######################################################
#catalog_bkp_disabled
#
#Inputs - none
#
#Returns - none
#
#Algorithm -
#####################################################

sub catalog_bkp_disabled {
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd =
      $admincmd_dir . "bperror -U -d $start_time -e $end_time -columns 300\n";
    my $bperroutput = `$cmd`;

    if ( $^O =~ /MSWin/i ) {
        if ( ( $bperroutput =~ /database backup is currently disabled/i ) ) {
`eventcreate /T ERROR /ID 1000 /L APPLICATION /D "Catalog Backup Disabled" /SO "Netbackup_Monitoring"`;
        }
    }
    else {
        open( LOGFILE, "+>> $logfile " );
        my $cronoutput = `crontab -l`;

        if (
            (
                $bperroutput =~
                /NetBackup database backup is currently disabled/
            )
            && ( $cronoutput =~ /bpbackupdb/ )
          )
        {
            my $str_found = "0";
        }
        elsif (
            (
                $bperroutput =~
                /NetBackup database backup is currently disabled/
            )
            && ( $cronoutput !~ /bbackupdb/ )
          )
        {
            print LOGFILE "Catalog Backup Disabled\n";
        }

        open( CATDISABLEDCRON, "crontab -l |" );
        while ( readline *CATDISABLEDCRON ) {
            my @data1 = split( / /, $_ ) if ( $_ =~ /bpbackupdb/ );
            print LOGFILE "Catalog Backup Disabled\n"
              if ( $data1[0] =~ /\#/ ) && ( my $str_found == "0" );
        }
        close(CATDISABLEDCRON);

        close(LOGFILE);
    }
}

############################################################
# media_get_jobids
#
# Inputs: none
#
# Returns:  none
#
# Algorithm: Get all jobid nos in an array from bpdbjobs command output which were active in last 10 min
#
#############################################################

sub media_get_jobids {
    my @jobs;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir . "bpdbjobs";
    open( CMD, "$cmd |" );
    while ( readline *CMD ) {
        $_ =~ s/^ *//;
        $_ =~ y/ / /s;
        my @data = split( / /, $_ ) if ( $_ =~ /Done/ );
        my $jobid = $data[0];
        my $output =
          $admincmd_dir . "bperror -jobid $jobid -d $start_time -e $end_time";
        my @output = `$output` if ( length($jobid) > "0" );
        my $nums = scalar(@output);
        push( @jobs, $jobid ) if ( $nums > "0" );

    }
    close(CMD);
    return @jobs;
}

######################################################
# specific_media
#
# Inputs: $job - from $jobid_store
#
# Returns: none
#
# Algorithm: Check the bperror command output for last 10 min for the job and if error code found then write the
#            entry in logfile.
#
#####################################################

sub specific_media {

    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat -columns 300";

    open( SPECMEDIA, "$cmd |" );
    my @data = <SPECMEDIA>;
    chomp $data[1];
    $data[1] =~ s/^ *//;
    $data[1] =~ tr/ / /s;
    my @errorcode = split( / /, $data[1] );
    if ( $errorcode[0] == 219 ) {
        if ( $^O =~ /MSWin/i ) {

`eventcreate /T ERROR /ID 1000 /L APPLICATION /D "JOBID:$jobid Required media not available for Backup" /SO $jobid`;
        }
        else {

            open( LOGFILE, "+>> $logfile" );
            print LOGFILE
              "Required media not available with JOBID:$jobid $data[1]\n";
            close(LOGFILE);
        }
    }
    close(SPECMEDIA);
}

######################################################
# no_media
#
#Inputs: $job - from $jobid_store
#
# Returns: none
#
# Algorithm: Check the bperror command output for last 10 min for the job and if error code found then write the
#            entry in logfile.
#
#####################################################

sub no_media {

    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat -columns 300";

    open( NOMEDIA, "$cmd |" );
    my @data = <NOMEDIA>;
    chomp $data[1];
    $data[1] =~ s/^ *//;
    $data[1] =~ tr/ / /s;
    my @errorcode = split( / /, $data[1] );
    if ( $errorcode[0] == 96 ) {
        if ( $^O =~ /MSWin/i ) {

`eventcreate /T ERROR /ID 1000 /L APPLICATION /D "JOBID:$jobid Required media not available for Backup" /SO $jobid`;
        }
        else {

            open( LOGFILE, "+>> $logfile" );
            print LOGFILE "No Media available with JOBID:$jobid $data[1]\n";
            close(LOGFILE);
        }
    }
    close(NOMEDIA);
}

######################################################
# frozen_media
#
# Inputs: $job - from $jobid_store
#
# Returns : none
#
# Algorithm: Check the bperror command output for last 10 min and if specific string found then write the
#            entry in logfile.
#
#####################################################

sub frozen_media {
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $cmd =
      $admincmd_dir . "bperror -d $start_time -e $end_time -U -columns 300";

    open( FROZENMEDIA, "$cmd |" );
    while ( readline *FROZENMEDIA ) {
        if ( $_ =~ /FREEZING/ ) {
            $_ =~ tr/ / /s;
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T ERROR /ID 1000 /L APPLICATION /D "Media:$_ Media is FROZEN" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile" );
                print LOGFILE "FROZEN MEDIA $_\n";
                close(LOGFILE);
            }
        }
    }
    close(FROZENMEDIA);
}

############################################################
# restore_get_jobids
#
# Inputs: bpdbjobs command output
#
# Returns:  none
#
# Algorithm: Get Restore jobid nos in a file from bpdbjobs command output which were active in last 10 min
#
#############################################################

sub restore_get_jobids {
    my @jobs;
    my ( $end_time, $start_time ) = get_time;
    my $cmd      = $admincmd_dir . "bpdbjobs -gdm";
    my $cur_time = time();
    open( CMD, "$cmd |" );
    while (<CMD>) {
        my @data;
        my $jobid;
        my $jobtype;
        @data = split( /,/, $_ );
        my $period = $cur_time - $data[10];
        $jobtype = $data[1]
          ; # jobtype status code - (0=backup, 1=archive, 2=restore, 3=verify, 4=duplication, 5=import, 6=dbbackup, 7=vault)
        if ( $jobtype == 2 && $period < 1800 ) {
            $jobid = $data[0];
            my $output = $admincmd_dir
              . "bperror -jobid $jobid -d $start_time -e $end_time";
            my @output = `$output` if ( length($jobid) > "0" );
            my $nums = scalar(@output);
            push( @jobs, $jobid ) if ( $nums > "0" );
        }
    }
    close(CMD);
    return @jobs;
}

######################################################
# restore_start
#
# Inputs: $job - Jobid
#
# Rerurns: none
#
# Algorithm: For jobid check the bperror command output,
#            whether specific string is found and if found wtite the info to log file
#
#
#####################################################

sub restore_start {

    my $jobid = $_[0];
    my ( $end_time, $start_time ) = get_time;
    my $logfile = $UN_logfile;
    my $CMD     = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -columns 300";

    open( RESTORESTART, "$CMD |" );
    while ( readline *RESTORESTART ) {
        if ( $_ =~ /reading backup id/ ) {
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Restore has started" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile " );
                print LOGFILE "JOBID:$_[0] $_\n";
                close(LOGFILE);
            }
        }
    }
    close(RESTORESTART);
}

######################################################
# restore_finish
#
# Inputs: $job - Jobid
#
# Rerurns: none
#
# Algorithm: For jobid check the bperror command output,
#            whether specific string is found and if found wtite the info to log file
#
#
#####################################################

sub restore_finish {

    my $jobid   = $_[0];
    my $logfile = $UN_logfile;
    my ( $end_time, $start_time ) = get_time;
    my $CMD = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -columns 300";

    open( RESTOREFINISH, "$CMD |" );
    while ( readline *RESTOREFINISH ) {
        if ( $_ =~ /successfully (read|restored)/ ) {
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Restore has Finished" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile " );
                print LOGFILE "JOBID:$_[0] $_\n";
                close(LOGFILE);
            }
        }
    }
    close(RESTOREFINISH);
}

######################################################
# restore_aborted
#
# Inputs: $job - Jobid
#
# Rerurns: none
#
# Algorithm: For jobid check the bperror command output,
#            whether specific string is found and if found wtite info to log file
#
#
#####################################################

sub restore_aborted {
    my $jobid = $_[0];
    my ( $end_time, $start_time ) = get_time;
    my $logfile = $UN_logfile;
    my $CMD     = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -columns 300";

    open( RESTOREABORT, "$CMD |" );
    while ( readline *RESTOREABORT ) {
        if ( $_ =~ /Restore must be resumed/ ) {
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Restore has been aborted" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile " );
                print LOGFILE "JOBID:$_[0] $_\n";
                close(LOGFILE);
            }
        }
    }
    close(RESTOREABORT);
}

######################################################
# restore_failed
#
# Inputs: $job - Jobid
#
# Rerurns: none
#
# Algorithm: For jobid check the bperror command output,
#            whether specific string is found and if found wtite the info to log filefile
#
#
#####################################################

sub restore_failed {
    my $jobid = $_[0];
    my ( $end_time, $start_time ) = get_time;
    my $logfile = $UN_logfile;
    my $CMD     = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -columns 300";

    open( RESTOREFAILED, "$CMD |" );
    while ( readline *RESTOREFAILED ) {
        if ( $_ =~ /media manager terminated by signal/ ) {
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Restore has Failed" /SO "Netbackup_Monitoring"`;
            }
            else {
                my @data = split( / /, $_ );
                open( LOGFILE, "+>> $logfile " );
                print LOGFILE "JOBID:$_[0] $_\n";
                close(LOGFILE);
            }
        }
    }
    close(RESTOREFAILED);
}

######################################################
# restore_failed_bycode
#
# Inputs: $job - Jobid
#
# Rerurns: none
#
#Algorithm: For jobid check the bperror command output,
#            whether specific error code is found and if found wtite the info to log file
#
#
#####################################################

sub restore_failed_bycode {

    my $jobid = $_[0];
    my ( $end_time, $start_time ) = get_time;
    my $logfile = $UN_logfile;
    my $CMD     = $admincmd_dir
      . "bperror -jobid $jobid -d $start_time -e $end_time -U -backstat -columns 300";

    open( RESTOREFAIL, "$CMD |" );
    while ( readline *RESTOREFAIL ) {
        my @data = $_;
        chomp $data[1];
        $data[1] =~ s/^ *//;
        $data[1] =~ tr/ / /s;
        my @job = split( / /, $data[1] );
        if (   ( $job[0] == 5 )
            || ( $job[0] == 53 )
            || ( $job[0] == 175 )
            || ( $job[0] == 185 )
            || \( $job[0] == 201 )
            || ( $job[0] == 202 )
            || ( $job[0] == 203 )
            || ( $job[0] == 204 )
            || \( $job[0] == 205 )
            || ( $job[0] == 206 ) )
        {
            if ( $^O =~ /MSWin/i ) {
`eventcreate /T INFORMATION /ID 1000 /L APPLICATION /D "JOBID:$jobid Restore has failed with errorcode $job[0]" /SO "Netbackup_Monitoring"`;
            }
            else {
                open( LOGFILE, "+>> $logfile" );
                print LOGFILE "Restore Failed with JOBID:$_[0] $data[1]\n";
                close(LOGFILE);
            }
        }
    }
    close(RESTOREFAIL);
}

######################################################################
##### Main ###

my $backup;
my $catalog;
my $media;
my $restore;
my $oslog;

GetOptions(
    "backup"  => \$backup,
    "catalog" => \$catalog,
    "media"   => \$media,
    "restore" => \$restore,
    "oslog"   => \$oslog
);

my $nos = chk_nbu_status();
if ( $nos >= 3 ) {

#check whether each jobid has any entries for backup start,backup queued,backup failed,backup abort,backup failed,backup completed in last 10 min.
    if ($backup) {

        &backup_queue();

        my @jobs = &backup_get_jobids();
        foreach my $job (@jobs) {

            &backup_start($job);

            #   &backup_queue();

            &backup_aborted($job);

            &backup_failed($job);

            &backup_completed($job);
        }
    }

#check whether each jobid has any entries for catalog backup failed in last 10 min and whether catalog backup is disabled.
    if ($catalog) {
        &catalog_bkp_disabled();
        my @jobs = &catalog_get_jobids();
        foreach my $job (@jobs) {
            &catalog_bkp_failed($job);
        }
    }

#for each jobid check whether any job is failed with not having specific media or for not gaving any media available.
    if ($media) {
        &frozen_media();
        my @jobs = &media_get_jobids();
        foreach my $job (@jobs) {

            &specific_media($job);

            &no_media($job);
        }
    }

#check whether any restore has started, finished, failed or aborted in last 10 min.
    if ($restore) {
        my @jobs = &restore_get_jobids();
        foreach my $job (@jobs) {

            &restore_start($job);

            &restore_finish($job);

            &restore_failed($job);

            &restore_failed_bycode($job);

            &restore_aborted($job);
        }
    }

#Checks the availability of the logfile and print it out to stdout to be used by OVO templates.
    if ( $oslog && $^O !~ /MSWin/i ) {
        my $oslogfile  = "/var/adm/syslog/syslog.log";
        my $oslogfile1 = "/var/adm/messages";
        if ( !-f $oslogfile ) {
            print "$oslogfile1";
        }
        else {
            print "$oslogfile";
        }
    }
}
else {

    exit;
}

