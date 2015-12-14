#!/usr/bin/perl -w
#######################################################
#	This script is used to check the following Items for the Post Maintenance window
#		1. The Mid-Tier availability, if mid-tier is UP and RUNNING
#		2. If Mid-Tiers are up and running with a clean log file(before the Started in line in the mid-tier log file)
#		3. Check if the FPA for each client are unsuspended
#
#	There is one configuration file for this script, This script rely on the configuration, the default configuration file
#	is "/asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg". If you dont supply a configuration file, the default
#	one is used
#
#	Usage:
#	./MT_maintenance_check.pl --help
#
#######################################################
#*******************************************************************************
# Date         Programmmer      Description
# ----------   --------------   ------------------------------------------
#1/1/2012     James.Zhu         version 1.0
#
#3/18/2012  James.Zhu         Added logging for who invoked this script with what options
#                                        to the begining of the script
#*******************************************************************************
use strict;
use warnings;

#including modules
use Data::Dumper;
use Getopt::Long;
use POSIX;
use File::Basename;

#Global variables for script
my %midtiers = ();
my $hostname;
my @running_mts = ();
$ENV{TNS_ADMIN} = "/OraStage/admin";
my $ssh_str;
my @mid_tiers        = ();
my %fpa_suspend_file = ();
my $fpa              = 0;
my $mt_ps_str;
my $start_time;
my $end_time;
my $LOG_P = "/asp/share/zhuj2/scripts/log";
my $LOG_F = $LOG_P . '/' . basename($0) . '.log';

#Global varibales for command line option checking
my $MT_CONF = "/asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg";
my $wts     = 0;
my $help    = 0;
my $preview = 0;
my $start   = 0;
my $mt_conf;
my @opt_midtier;
my $debug = 0;
my $version;
my $parameter = 0;
my $command;
my $args;
my $whoami;

#get current date/time
sub get_current_tm {
    my $subname = ( caller(0) )[3];
    my $time;
    $time = localtime;
    return $time;
}

#write log
sub write_log {
    my $caller = shift;
    my @args   = @_;
    chomp @args;

    my $msg = join( "\t", @args );
    my $time = &get_current_tm();

    open( SLOG, ">>$LOG_F" ) or die "Oops! $!\n";
    printf SLOG "%-30s%-30s%-20s\n", $caller, $time, $msg;
    if ($debug) {
        printf "%-30s%-30s%-20s\n", $caller, $time, $msg;
    }
    close SLOG;

}

sub whoami {
    my $subname = ( caller(0) )[3];
    my $whoami  = `who am i`;

    chomp $whoami;

    &write_log( $subname, "Executing as: $whoami" );

    $whoami = ( split /\s+/, $whoami )[0];

    return $whoami;
}

# sub Get_Host_name
# {
# open(HOST,"/usr/bin/ssh $ssh_str hostname 2>/dev/null|") or die "ERROR Getting hostname: $!\n";
# while(<HOST>){
# chomp ( $hostname = $_ );
# }
# close HOST;
# }

#read and print out the $MT_CONF file for this script
sub Print_conf_file_contents {
    my $subname = ( caller(0) )[3];
    &write_log( $subname,
        "executing /usr/bin/ssh $ssh_str \"/bin/cat $MT_CONF\" 2>/dev/null|" );
    open( CONF, "/usr/bin/ssh $ssh_str \"/bin/cat $MT_CONF\" 2>/dev/null|" )
      or die "ERROR reading $MT_CONF: $!\n";
    while (<CONF>) {
        &write_log( $subname, $_ );
        print;
    }
    close CONF;
}

#######################################################
#read and the $MT_CONF file for this script, the configuration file has the following syntax:
#HOST    	ID      	HOME DIRECTORY
# dialxpap01 nwprdcs /asp/nwhsp/nwhsprd/CS
# dialxpap01 nwprdpb /asp/nwhsp/nwhsprd/PB
# dialxpap02 dhprdcs /asp/dhhsp/dhhsprd/CS
# dialxpap02 svprdcs /asp/svhsp/shhsprd/CS
# dialxpap02 svprdpb /asp/svhsp/shhsprd/PB
#	INPUT: 		MT configuration file
#	OUTPUT: 	%midtiers
#######################################################
sub Read_ck_config {
    my $subname = ( caller(0) )[3];
    &Clean_Screen() if ($preview);

    &write_log( $subname, "Reading $MT_CONF" );

    open( FH, "$MT_CONF" ) or die "open $MT_CONF ERROR: $!";
    while (<FH>) {

        &write_log( $subname, $_ );

        if ($preview) {
            print;
        }
        else {
            chomp;
            next if (/^#/);
            next if (/^$/);
            $midtiers{ (split)[1] }{HOME} = (split)[2];
            $midtiers{ (split)[1] }{HOST} = (split)[0];
            if (/WTS/) {
                $midtiers{ (split)[1] }{WTS} = 1;
            }
        }
    }
    close(FH);
    if ($preview) {
        &write_log("Script ENDed running");
        exit;
    }
}

#######################################################
#Get the mid-tier parameters configuration file from $HOME/csmt/config/myConfig.properties
#	INPUT: 		mid-tier ID
#	OUTPUT: 	mid-tier parameters, like EJB, MIDTIER-ACCESS
#######################################################
sub Get_mt_paras_csmt_config {
    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];
    my $cfg_f   = $midtiers{$mt}{CFG};
    my $flag1   = 0;
    my $flag2   = 0;
    my $flag3   = 0;
    my $flag4   = 0;
    my $flag5   = 0;
    my $flag6   = 0;
    $midtiers{$mt}{IP} = "$midtiers{$mt}{HOST}";

    $ssh_str = &Get_Client_ID($mt);

    &write_log( $subname,
        "Executing \"/usr/bin/ssh $ssh_str \"/bin/cat $cfg_f\" 2>/dev/null|" );
    open( CFG, "/usr/bin/ssh $ssh_str \"/bin/cat $cfg_f\" 2>/dev/null|" )
      or die "open $cfg_f ERROR: $!";

    while (<CFG>) {

        if (/^LoadBalancingServiceImpl\.webServiceHost/) {
            chomp( $midtiers{$mt}{IP} = ( split /=/ )[1] );
            &write_log( $subname, "got IP for $mt: $midtiers{$mt}{IP}" );
            $flag6 = 1;
        }

        if (/^LoadBalancingServiceImpl\.webServicePort/) {
            chomp( $midtiers{$mt}{PORT} = ( split /=/ )[1] );
            &write_log( $subname, "got PORT for $mt: $midtiers{$mt}{PORT}" );
            $flag1 = 1;
        }

        if (/^JMS_PROVIDER_URL_VALUE/) {
            chomp( $midtiers{$mt}{EJB} = ( split /=/ )[1] );
            &write_log( $subname, "got EJB for $mt: $midtiers{$mt}{EJB}" );
            $flag2 = 1;
        }

        if (/^jdbc\.url/) {
            my @kvpair = $_ =~ m/(.*?)\=(.*)/;

#chomp ( $midtiers{$mt}{JDBCURL} = (split /=/)[1] );  This was a bug as there is '=' in the JDBC connection string
            $midtiers{$mt}{JDBCURL} = $kvpair[1];
            &write_log( $subname,
                "got JDBCURL for $mt: $midtiers{$mt}{JDBCURL}" );
            $flag3 = 1;
        }

        if (/^database\.password/) {
            chomp( $midtiers{$mt}{DBPW} = ( split /=/ )[1] );
            &write_log( $subname, "got DBPW for $mt: XXXXXXXXX" );
            $flag4 = 1;
        }

        if (/^database\.user/) {
            chomp( $midtiers{$mt}{DBUSER} = ( split /=/ )[1] );
            &write_log( $subname,
                "got DBUSER for $mt: $midtiers{$mt}{DBUSER}" );
            $flag5 = 1;
        }

        if ( $flag1 && $flag2 && $flag3 && $flag4 && $flag5 && $flag6 ) {
            last;
        }
    }

    shutdown CFG, 2;

}

sub build_java_cmd {
    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];

    my $jcmd;

    if ( $mt !~ /cs$/ ) { return 0; }

    $jcmd = 'java -cp /asp/share/zhuj2/scripts/bin ParameterCheck';

    $jcmd .= " $midtiers{$mt}{JDBCURL}";

    $jcmd .= " $midtiers{$mt}{DBUSER}";

    $jcmd .= " $midtiers{$mt}{DBPW}";

    &write_log( $subname, "Built JAVA CMD: $jcmd" );

    return $jcmd;

}

sub show_current_para {
    my $subname = ( caller(0) )[3];
    my $jcmd    = $_[0];

    $jcmd =~ s/\(/\\(/g;
    $jcmd =~ s/\)/\\)/g;
    $jcmd =~ s/@/\\@/g;

    &write_log( $subname, "Executing JAVA CMD: $jcmd" );
    open( JAVA, "$jcmd|" ) or die "Failed to execute $jcmd\n";
    while (<JAVA>) {
        &write_log( $subname, "$_" );
        print;
    }
    close JAVA;

}

sub show_para_in_csmt_config {
    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];
    my $mtacccess =
      'http://' . $midtiers{$mt}{IP} . ':' . $midtiers{$mt}{PORT} . '/';
    my $ejb = $midtiers{$mt}{EJB};

    print $mtacccess, "\n";
    print $ejb,       "\n";

    &write_log( $subname, "MIDACCESS: $mtacccess" );
    &write_log( $subname, "EJB: $ejb" );
}

#######################################################
#Set up MT LOG file(startServerBackground.log) location
#Set up MT CFG file(myConfig.properties) location
#######################################################
sub Gen_MT_info {
    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];

    &write_log( $subname,
        "Generating MT information, logfile, property files" );

    $midtiers{$mt}{LOG} =
      $midtiers{$mt}{HOME} . "/csmt/log/startServerBackground.log";
    $midtiers{$mt}{CFG} =
      $midtiers{$mt}{HOME} . "/csmt/config/myConfig.properties";

}

#######################################################
#	set up the ssh connecting string for the Remote server, ie. whhsp@dialxpap01
#######################################################
sub Get_Client_ID {
    my $subname   = ( caller(0) )[3];
    my $mt        = $_[0];
    my $client_id = ( split /\//, $midtiers{$mt}{CFG} )[2];

    $client_id = $client_id . '@' . $midtiers{$mt}{HOST};

    &write_log( $subname, "$client_id" );

    return $client_id;
}

sub Get_FPA_SUSPEND_FILE_localtion {
    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];

    &write_log($subname);

    my $client_id = ( split /\//, $midtiers{$mt}{CFG} )[2];

    &Build_FPA_SUSPEND_FILE_location( $client_id, $midtiers{$mt}{HOST} );

}

sub Build_FPA_SUSPEND_FILE_location {
    my $subname     = ( caller(0) )[3];
    my $client      = shift;
    my $client_host = shift;
    my $client_str  = substr( $client, 0, 2 );
    my $env_type    = substr( $client, 4 );

    my $fpa_suspend_file =
"/asp/${client}/fpa/home/${client_str}ftp${env_type}/system/jobs/scheduled/FPA_IS_SUSPENDED.DAT";

    unless ( exists $fpa_suspend_file{$client}{FPA_FILE} ) {
        $fpa_suspend_file{$client}{FPA_FILE} = $fpa_suspend_file;
        &write_log( $subname, $fpa_suspend_file{$client}{FPA_FILE} );
    }
    unless ( exists $fpa_suspend_file{$client}{HOST} ) {
        $fpa_suspend_file{$client}{HOST} = $client_host;
        $fpa_suspend_file{$client}{ASPADMIN_FPA_F} =
          "/asp/FPA/FPA_CONTROL_DIR/FPA_IS_SUSPENDED.DAT";
        &write_log( $subname, $fpa_suspend_file{$client}{HOST} );
    }

}

sub FPA_suspension_check {
    my $subname = ( caller(0) )[3];
    my $ret_code;

    print "This is to check FPA SUSPENSION for Clients\n";
    print
"**********************************************************************************************\n";
    foreach my $CLIENT ( keys %fpa_suspend_file ) {
        my $client_ssh_str = $CLIENT . '@' . $fpa_suspend_file{$CLIENT}{HOST};

        my $fpa_suspend_file     = $fpa_suspend_file{$CLIENT}{FPA_FILE};
        my $fpa_suspend_file_all = $fpa_suspend_file{$CLIENT}{ASPADMIN_FPA_F};

        &write_log( $subname,
"Executing /usr/bin/ssh $client_ssh_str \"/bin/ls $fpa_suspend_file\" 2>/dev/null"
        );
        my $output =
`/usr/bin/ssh $client_ssh_str \"/bin/ls $fpa_suspend_file\" 2>/dev/null`;

        &write_log( $subname, $output );

        $ret_code = $? >> 8;

        &write_log( $subname, "return code is:", $ret_code );

        if ( $ret_code == 0 ) {
            print
"Please check, the FPA for $CLIENT would probably be SUSPENDED, please check!\n";
        }
        else {
            print "The FPA for $CLIENT IS NOT SUSPENDED!\n";
        }

        &write_log( $subname,
"/usr/bin/ssh $client_ssh_str \"/bin/ls $fpa_suspend_file_all\" 2>/dev/null"
        );
        my $output1 =
`/usr/bin/ssh $client_ssh_str \"/bin/ls $fpa_suspend_file_all\" 2>/dev/null`;

        &write_log( $subname, $output1 );

        $ret_code = $? >> 8;

        &write_log( $subname, "return code is:", $ret_code );

        if ( $ret_code == 0 ) {
            print
"Please check, the FPA for would probably be SUSPENDED for ALL Client on $fpa_suspend_file{$CLIENT}{HOST} by aspadmin, please check!\n";
        }
        else {
            &write_log( $subname,
                "FPA is not suspended for ALL client as aspadmin" );
        }

    }
    print
"**********************************************************************************************\n";

}

#######################################################
#	ssh to Remote server and get the running Mid-Tier processes table
#######################################################
sub Get_running_MTs {
    my $subname = ( caller(0) )[3];

    &write_log( $subname,
        "/usr/bin/ssh $ssh_str \"/asp/share/bin/links/CS_PS.ksh\" 2>/dev/null|"
    );
    open( PROC,
        "/usr/bin/ssh $ssh_str \"/asp/share/bin/links/CS_PS.ksh\" 2>/dev/null|"
    ) or die "running cs command failed: $!";
    while (<PROC>) {
        push @running_mts, $_;
    }
    close PROC;
}

#######################################################
#	Check if the Mid-Tier is up and running, If the mid-tier exists in the Mid-Tier processes table which retrived by &Get_running_MTs function
#######################################################
sub Are_mt_running {
    my $subname = ( caller(0) )[3];
    my $mt_id   = $_[0];

    #	my $mt_port = $_[1];
    my $ret = 0;

    &write_log($subname);

    &Get_running_MTs();
    foreach (@running_mts) {

        if (/^\Q$mt_id\E/) {
            &write_log( $subname, $_ );
            $mt_ps_str = $_;
            $ret       = 1;
            return $ret;
        }
    }
    return $ret;
}

#######################################################
#	Ssh to Remote server, to check log files for the Mid-Tier instances
#######################################################
sub MT_Error_check {
    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];

    my $logfile = $midtiers{$mt}{LOG};

    &write_log( $subname,
"Executing /usr/bin/ssh $ssh_str \"/bin/cat $logfile|sed '/Started in/q'\" 2>/dev/null|"
    );

    open( LOG,
"/usr/bin/ssh $ssh_str \"/bin/cat $logfile|sed '/Started in/q'\" 2>/dev/null|"
    ) or die "Open $logfile Error: $!";
    while (<LOG>) {
        if (/ERROR|error|FATAL|fatal/) {
            s/^\s+//;

            &write_log( $subname, $_ );

            print;

        }
        elsif (/Started in/) {
            s/^\s+//;
            &write_log( $subname, $_ );
            print;
            last;
        }
    }

    #close LOG;
    shutdown LOG, 2;

}

#######################################################
#	Ssh to Remote server, to check for the Mid-Tier current version
#######################################################
sub get_version {

    my $subname = ( caller(0) )[3];
    my $mt      = $_[0];
    my $ver_str;

    $ssh_str = &Get_Client_ID($mt);

    &write_log( $subname,
"executing /usr/bin/ssh $ssh_str \"tail -1 $midtiers{$mt}{HOME}/version.txt\" 2>/dev/null|"
    );
    open( VERSION,
"/usr/bin/ssh $ssh_str \"tail -1 $midtiers{$mt}{HOME}/version.txt\" 2>/dev/null|"
    ) or die "Open Error: $!";
    while (<VERSION>) {
        $ver_str .= $_;
    }

    #close VERSION;
    shutdown VERSION, 2;

    &write_log( $subname, "The version of $mt is: $ver_str" );
    return $ver_str;
}

sub Clean_Screen {
    my $subname      = ( caller(0) )[3];
    my $clear_string = `clear`;
    print $clear_string;

    &write_log($subname);
}

sub Wts_check {
    my $subname = ( caller(0) )[3];
    &Clean_Screen();

    &write_log($subname);

    my @wts_mt = sort keys %midtiers;
    print "This is to prompts you to check WTS connectivity\n";
    print
"*************************************************************************************************************\n";
    foreach my $wts (@wts_mt) {

        &write_log( $subname, $wts );

        if ( $midtiers{$wts}{WTS} ) {
            print
"Please check the WTS connectivity using Mid-Tier ID $wts on $midtiers{$wts}{HOST} \n";
        }
    }
    print
"\nFor Example: dir-chk OR unc-chk in the \$HOME/bin directory are used for WTS connectivity verification\n";
    print
"*************************************************************************************************************\n";

}

sub Usage {
    my $subname = ( caller(0) )[3];

    &Clean_Screen();

    &write_log( $subname, "print USAGE message" );

    print "Usage: $0 [OPTION]...\n";
    print "OPTIONS\n";
    print
"	-c, --config	Supply the configuratioin files in which Mid-Tiers are listed, syntax like below,\n";
    print
"			If no configuration file supplied, it will use the default configurations, \n";
    print "			which is $MT_CONF\n";
    print "\n";
    print "			HOST    	ID      	HOME DIRECTORY			WTS ID(Optional)\n";
    print "			dialxpap02	svprdcs 	/asp/svhsp/shhsprd/CS		WTS	\n";
    print "			dialxpap02	ppprdhp 	/asp/pphsp/pphsprd/HP		WTS	\n";
    print "			dialxpap01	nwprdpb		/asp/nwhsp/nwhsprd/PB		\n\n";

    print
"	-s, --start	Used to start the Mid-Tier check, If dont supply configuration file, use the default one\n";
    print "	-f, --fpa	Used to start FPA Suspension check\n";
    print
"	-w, --wts	Used to check the WTS connectivities, you should run this option with the Mid-Tier\n";
    print "			CS/HP ID, like chprdcs, whprdcs, and so on\n";
    print
"			Notice: This option is not automated yet, It only show you what you need to check!\n\n";

    print
"	-m, --midtier	Used to check a specific Mid-Tier, Which should have been configured in configuration file you specified\n";

    print
"	-v  --version	Check the current version of Mid-Tier, with -m option to check specific Mid-Tier\n";

    print "	-h, --help	Used to print this help\n";

    print "	-p, --preview	Used to preview the configuratoin file\n";

    print "	-t, --parameter	Used to check the parameters of mid-tier(s)\n\n";

    print "Examples:\n";
    print
"	$0 -s -c /asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg(-c is optional)\n";
    print
"	$0 -s -m svprdcs -c /asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg(-c is optional)\n";
    print
"	$0 -v -m svprdcs -c /asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg(-c is optional)\n";
    print
      "	$0 -v -m svprdcs svprdpb (you can specify multiple midtier to check)\n";
    print
"	$0 -p -c /asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg(-c is optional)\n";
    print
"	$0 -f -c /asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg(-c is optional)\n";
    print
"	$0 -t -m svprdcs -c /asp/share/zhuj2/scripts/etc/MT_maintenance_check.cfg(-c is optional)\n";
    print "	$0 -w \n";
    print "	$0 -h\n";
}

#######################################################
#start check Mid-Tier components
#######################################################
sub MT_Check {
    my $subname = ( caller(0) )[3];
    my @mt      = @_;

    &write_log( $subname, "Starting MT check" );

    foreach my $midtier (@mt) {

        &write_log( $subname, "foreach MT $midtier" );
        $ssh_str = &Get_Client_ID($midtier);

        &write_log( $subname, "Get remote ssh string $ssh_str" );

        #		&Get_mt_paras_csmt_config( $midtier );

        print
"++++++++++++	Checking MIDTIER $midtier on $midtiers{$midtier}{HOST}	++++++++++++\n";
        print
"-----------------------------------------------------------------------------------------------------------------\n";
        print
          "Starting to check IF the Mid-Tier $midtier is/are UP and RUNNING \n";
        print
"-----------------------------------------------------------------------------------------------------------------\n";
        if ( &Are_mt_running( $midtier, $midtiers{$midtier}{PORT} ) ) {
            print "$mt_ps_str";
            $mt_ps_str = undef;
            print "\n\n";
            print
"Starting to check IF there is/are ERRORs in Mid-Tier $midtier LOGFILE before the Started in line\n";
            print
"-----------------------------------------------------------------------------------------------------------------\n";
            &MT_Error_check($midtier);
        }
        else {
            print
              "		Mid-Tier $midtier is NOT up and running, you should check! \n";
        }
        print "\n\n\n";

    }
}

sub is_midtier_configured {
    my $subname = ( caller(0) )[3];
    my $mt      = shift;
    if ( exists $midtiers{$mt} ) {

        &write_log( $subname, "$mt exists in hash" );

        return 1;
    }
    else {

        &write_log( $subname, "$mt does not exist in hash" );
        return 0;
    }
}

#######################################################
#MAIN starts here
#######################################################
&write_log("Script started running");
$whoami = &whoami();

$args = join( ' ', @ARGV );
$command = $0 . ' ' . $args;
my $msg = "$whoami issued command $command";
&write_log( "MAIN", $msg );

if ( scalar @ARGV <= 0 ) {
    &Usage();
    &write_log("Script ENDed running");
    exit;
}

&GetOptions(
    'config|c=s'         => \$mt_conf,
    'wts|w'              => \$wts,
    'start|s'            => \$start,
    'preview|p'          => \$preview,
    'fpa|f'              => \$fpa,
    'midtier|m=s{,}'     => \@opt_midtier,
    'help|h'             => \$help,
    'debug|d'            => \$debug,
    'version|v'          => \$version,
    'system_parameter|t' => \$parameter
);

if ($debug) {
    $debug = 1;
}

if ($help) {
    &Usage();
    &write_log("Script ENDed running");
    exit;
}

if ( defined $mt_conf ) {
    $MT_CONF = $mt_conf;
}

&Read_ck_config();

if ( scalar @opt_midtier >= 1 ) {

    @mid_tiers = ();

    foreach my $midtier (@opt_midtier) {
        if ( &is_midtier_configured($midtier) ) {
            push @mid_tiers, $midtier;
        }
        else {
            print
"The Mid-tier you specified in the command line is not configured in configuration file $MT_CONF, Please pick one in it\n";
            &write_log("Script ENDed running");
            exit;
        }
    }
}
else {
    @mid_tiers = ();
    @mid_tiers = sort keys %midtiers;
}

foreach my $mt (@mid_tiers) {
    &Gen_MT_info($mt);
    &Get_mt_paras_csmt_config($mt);
}

if ($parameter) {

    foreach my $mt (@mid_tiers) {
        $ssh_str = &Get_Client_ID($mt);

        unless ( &Are_mt_running($mt) ) {
            print
"-------------------------------------------------------------------------------------------------------------------------\n";
            print
"Mid-Tier $mt is NOT up and running, you should check to see if it's under refreshing\n";
            print
"-------------------------------------------------------------------------------------------------------------------------\n";
            next;
        }
        my $jcommand;
        unless ( $jcommand = &build_java_cmd($mt) ) { next; }
        print
"-------------------------------------------------------------------------------------------------------------------------\n";
        print "The current parameters setting in database for $mt is below:\n";
        print '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@',
          "\n";
        &show_current_para($jcommand);
        print
"+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
        print
"The currect parameters setting for $mt in $midtiers{$mt}{CFG} is as below:\n";
        print '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n',
          "\n";
        &show_para_in_csmt_config($mt);
        print
"-------------------------------------------------------------------------------------------------------------------------\n";
    }

    &write_log("Script ENDed running");
    exit

}

if ($version) {

    foreach my $mt (@mid_tiers) {
        print "\nThe current Mid-Tier version for $mt is below\n";
        my $version_string = &get_version($mt);
        print $version_string;
    }
    exit;
}

if ($fpa) {

    foreach my $mt (@mid_tiers) {
        &Get_FPA_SUSPEND_FILE_localtion($mt);
    }
    &FPA_suspension_check();
    &write_log("Script ENDed running");
    exit;
}

if ($wts) {

    &Wts_check();
    &write_log("Script ENDed running");
    exit;

}

if ($start) {

    &MT_Check(@mid_tiers);

}
else {

    &Usage();
    &write_log("Script ENDed running");
    exit;

}

&write_log("Script ENDed running");

