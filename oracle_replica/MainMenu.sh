#!/bin/bash
#
# ---------------------------------------------------------------------------
# J.Munoz -+- 3rd November 2004
# Rewritten to simplify and remove common code
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

# Main Menu
main_menu() {

	dialog \
		--timeout $timeout \
		--backtitle $"$backtitle"\
		--title "Main Menu"\
		--nocancel \
		--item-help \
		--menu "Choose an option:" $box_height $box_width $menu_height\
	1	"Oracle Replica"      "Replicate Production Databases"\
	2	"Files Replica"       "Replicate Production Environment"\
	3	"Maintenance"	      "Local Maintenance"\
	0	"Exit"                "Logout"   2>$TEMP


CHOICE=`cat $TEMP`
echo $CHOICE

case $CHOICE in
	1) 
	   ./Oracle.sh;
	   main_menu;;
	2) 
	   ./Prod.sh;
	   main_menu;;
	3)
	   ./Maintenance.sh;
	   main_menu;;
	*)
	   clean_up;;
esac
}

# Call Main Menu when the script starts
main_menu
