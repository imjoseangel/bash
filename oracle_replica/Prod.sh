#!/bin/bash
# ---------------------------------------------------------------------------
# J.Munoz -+- 3rd November 2010
# SystemDaemons.sh
#
functions=`dirname $0`/functions
if [ -f $functions ]; then
. $functions
else
   exit
fi

# Trap Control-C
trap '' 2

# Temporary File
TEMP=${tmpdir}/answer$$

# Main Menu
main_menu() {

	dialog \
		--timeout $timeout \
		--backtitle $"$backtitle"\
		--title "Files Replica"\
		--nocancel \
		--item-help \
		--menu "Choose an option:" $box_height $box_width $menu_height\
  1	"Preproduction - Replica:"     "Replicate Files to Preproduction Environment:"\
  2	"Develop - Replica:"	       "Replicate Files to Development Environment:"\
  0	"Return"                       "Close this menu" 2> $TEMP
  CHOICE=`cat $TEMP`

# Here are defined all the task for every option.

case $CHOICE in
1)
./StartEnv.sh Pre-Production 10.100.45.26;
main_menu;;

2)
./StartEnv.sh Develop 10.100.45.27;
main_menu;;

*) 
   clean_up;;
esac
}
# Call main menu script
main_menu
