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

# Start DOWNSTBY
st_downstby()
{
	clear

        info_box "Starting Local DB"
        
        #Start Local DB
        
	export ORACLE_SID=DOWNSTBY
        sqlplus / as sysdba @/home/replica/menu/startstandby.sql &>/dev/null
        
	message_box "Downstream Database Started"

}

# Copy Upstream
st_transtby()
{
	clear

        info_box "Starting Local DB"
        
        #Start Local DB
        
	export ORACLE_SID=TRANSTBY
        sqlplus / as sysdba @/home/replica/menu/startstandby.sql
        
        message_box "Upstream Database Started"
        
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
	1	"Start Downstream"   "Start Local DownStream Database"\
	2	"Start Upstream"     "Start Local Upstream (Transaction) Database"\
	0	"Return"                        "Close this menu"   2>$TEMP

	CHOICE=`cat $TEMP`

	case $CHOICE in
		1) 
		   st_downstby;
		   main_menu;;
		2) 
		   st_transtby;
		   main_menu;;
		*) 
		   clean_up;
	esac

}


# Call Main Menu when the script starts
main_menu
