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

computer=$1
ip_address=$2
backup=`ls /opt/backup/backup-full-*.log | cut -d"/" -f 5 | cut -d"." -f1`.tgz


#Define Success Variable
SUCCESS=0

# Copy Downstream
cp_downstream()
{
	clear
	title=$computer" - Downstream Files"

	#Check if File Exists
	
	check_remote /tmp/$backup $ip_address
	
	copy_progress /opt/backup/$backup user@$ip_address:/tmp "(1/2) Package copying progress..."
        if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File copied to Server"
                else
                        message_box "ERROR -  File not copied to Server"
        fi

	clear
	info_box "Please wait ..."
	untar_progress /tmp/$backup / "(2/2) Package extracting progress..." $ip_address downstream
	if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File extracted to Server"
                else
                        message_box "ERROR -  File not extracted to Server"
        fi

	check_remote /tmp/$backup $ip_address
}

# Copy Upstream
cp_upstream()
{
	clear
        title=$computer" - Upstream Files"

        #Check if File Exists

        check_remote /tmp/$backup $ip_address

        copy_progress /opt/backup/$backup user@$ip_address:/tmp "(1/2) Package copying progress..."
        if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File copied to Server"
                else
                        message_box "ERROR -  File not copied to Server"
        fi

        clear
        info_box "Please wait ..."
        untar_progress /tmp/$backup / "(2/2) Package extracting progress..." $ip_address upstream
        if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File extracted to Server"
                else
                        message_box "ERROR -  File not extracted to Server"
        fi

        check_remote /tmp/$backup $ip_address
}

# Copy All
copy_all()
{
	clear
        title=$computer" - Environment Files"

        #Check if File Exists

        check_remote /tmp/$backup $ip_address

        copy_progress /opt/backup/$backup user@$ip_address:/tmp "(1/3) Package copying progress..."
        if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File copied to Server"
                else
                        message_box "ERROR -  File not copied to Server"
        fi

        clear
        info_box "Please wait ..."
        untar_progress /tmp/$backup / "(2/3) Package extracting progress..." $ip_address downstream
        if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File extracted to Server"
                else
                        message_box "ERROR -  File not extracted to Server"
        fi

	clear
        info_box "Please wait ..."
        untar_progress /tmp/$backup / "(3/3) Package extracting progress..." $ip_address upstream
        if [ "$?" -eq $SUCCESS ]
                then
                        message_box "SUCCESS - Backup File extracted to Server"
                else
                        message_box "ERROR -  File not extracted to Server"
        fi

        check_remote /tmp/$backup $ip_address
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
	3	"$computer - Copy All"          "Copy both Downstream and Upstream Databases"\
	0	"Return"                        "Close this menu"   2>$TEMP

	CHOICE=`cat $TEMP`

	case $CHOICE in
		1) 
		   cp_downstream;
		   main_menu;;
		2) 
		   cp_upstream;
		   main_menu;;
		3) 
		   copy_all;
		   main_menu;;
		*) 
		   clean_up;
	esac

}


# Call Main Menu when the script starts
main_menu
