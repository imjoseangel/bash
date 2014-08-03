#!/bin/bash
#
# ---------------------------------------------------------------------------
# J.Munoz -+- 22nd July 2011
# First Version
# ----------------------------------------------------------------------------

functions=`dirname $0`/functions
if [ -f $functions ]; then
    . $functions
else
   exit
fi

# Trap Control-C
trap '' 2

# temporary file
TEMP=/${tmpdir}/answer$$

computer=$1
ip_address=$2

#Define Success Variable
SUCCESS=0

#Define Oracle Variables
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
export PATH=$PATH:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

# Copy Downstream
cp_downstream()
{
	clear
	title=$computer" - Downstream Database"
				
	#Stop Local DB
				
	info_box "Stopping Local DB"
				
	export ORACLE_SID=DOWNSTBY
	sqlplus / as sysdba @/home/replica/menu/stopstandby.sql &>/dev/null
				
	#Stop Remote DB
				
	info_box "Stopping Remote DB"
				
	sqlplus sys/ar1ba9_0racle@$ip_address:1522/downstream as sysdba @/home/replica/menu/stopdb.sql &>/dev/null
	
	#Remove hidden files
				
	check_remotedb /opt/oraclesec/oradata/downstream/.* $ip_address
				
	# Rename downstream directory

	ssh oracle@$ip_address "rm /opt/oraclesec/oradata/downstream -rf"
	ssh oracle@$ip_address "mkdir /opt/oraclesec/oradata/downstream"

	# Copy Files
			
	copy_progress "/opt/oracle/oradata/DOWNSTBY/system01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(1/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/undotbs01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(2/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/sysaux01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(3/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/users01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(4/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/downprod01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(5/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/downprod02.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(6/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/downprod03.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(7/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/downprod04.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(8/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/downprod05.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(9/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/temp01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(10/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo01.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(11/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo02.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(12/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo03.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(13/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo04.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(14/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo05.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(15/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo06.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(16/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo07.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(17/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo08.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(18/19) Database copying progress..."

        copy_progress "/opt/oracle/oradata/DOWNSTBY/redo09.log" oracle@$ip_address:/opt/oraclesec/oradata/downstream/ "(19/19) Database copying progress..."

        ### if [ "$?" -eq $SUCCESS ]
        ###        then
        ###                message_box "SUCCESS - Backup File copied to Server"
        ###        else
        ###                message_box "ERROR -  File not copied to Server"
        ### fi
        
        #Build DB
        
        info_box "Building Database"
        
        scp /home/replica/menu/builddownstream.sql oracle@$ip_address:/home/oracle
        scp /home/replica/menu/builddownstream.sh oracle@$ip_address:/home/oracle

        ssh oracle@$ip_address "/home/oracle/builddownstream.sh"
        
        info_box "Starting Local DB"
        
        #Start Local DB
        
	export ORACLE_SID=DOWNSTBY
        sqlplus / as sysdba @/home/replica/menu/startstandby.sql &>/dev/null
        
	message_box "Downstream Database Copy Completed"

}

# Copy Upstream
cp_upstream()
{
	clear
	title=$computer" - Upstream Database"
				
	#Stop Local DB
				
	info_box "Stopping Local DB"
				
	export ORACLE_SID=TRANSTBY
	sqlplus / as sysdba @/home/replica/menu/stopstandby.sql &>/dev/null
				
	#Stop Remote DB
				
	info_box "Stopping Remote DB"
				
	sqlplus sys/ar1ba9_0racle@$ip_address:1522/transaction as sysdba @/home/replica/menu/stopdb.sql &>/dev/null
	
	#Remove hidden files
				
	check_remotedb /opt/oraclesec/oradata/transaction/.* $ip_address
				
	# Rename upstream directory
							
	ssh oracle@$ip_address "rm /opt/oraclesec/oradata/transaction -rf"
	ssh oracle@$ip_address "mkdir /opt/oraclesec/oradata/transaction"
			
        # Copy Files

        copy_progress "/opt/oracle/oradata/TRANSTBY/system01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(1/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/undotbs01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(2/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/sysaux01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(3/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/users01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(4/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(5/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod02.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(6/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod03.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(7/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod04.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(8/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod05.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(9/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod06.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(10/21) Database copying progress..."
       
        copy_progress "/opt/oracle/oradata/TRANSTBY/tranprod07.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(11/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/temp01.dbf" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(12/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo01.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(13/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo02.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(14/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo03.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(15/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo04.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(16/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo05.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(17/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo06.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(18/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo07.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(19/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo08.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(20/21) Database copying progress..."

        copy_progress "/opt/oracle/oradata/TRANSTBY/redo09.log" oracle@$ip_address:/opt/oraclesec/oradata/transaction/ "(21/21) Database copying progress..."

        ### if [ "$?" -eq $SUCCESS ]
        ###        then
        ###                message_box "SUCCESS - Backup File copied to Server"
        ###        else
        ###                message_box "ERROR -  File not copied to Server"
        ### fi
        
        #Build DB
        
        info_box "Building Database"
        
	scp /home/replica/menu/buildtransaction.sql oracle@$ip_address:/home/oracle
	scp /home/replica/menu/buildtransaction.sh oracle@$ip_address:/home/oracle

	ssh oracle@$ip_address "/home/oracle/buildtransaction.sh"

        info_box "Starting Local DB"
        
        #Start Local DB
        
	export ORACLE_SID=TRANSTBY
        sqlplus / as sysdba @/home/replica/menu/startstandby.sql
        
        message_box "Upstream Database Copy Completed"
        
}

# Short Menu - showing basic options
main_menu() 
{
	dialog \
		--timeout $timeout \
		--backtitle $"$backtitle"\
		--title $"$computer Replica"\
		--nocancel \
		--item-help \
		--menu "Choose an option:" $box_height $box_width $menu_height\
	1	"$computer - Copy Downstream"   "Copy DownStream Database"\
	2	"$computer - Copy Upstream"     "Copy Upstream (Transaction) Database"\
	0	"Return"                        "Close this menu"   2>$TEMP

	CHOICE=`cat $TEMP`

	case $CHOICE in
		1) 
		   cp_downstream;
		   main_menu;;
		2) 
		   cp_upstream;
		   main_menu;;
		*) 
		   clean_up;
	esac

}


# Call Main Menu when the script starts
main_menu
