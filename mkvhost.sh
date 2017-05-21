#!/usr/bin/env bash

# Variables
VHOSTNAME=$1
TIER=$2

HTTPDCONF=/etc/httpd/conf/httpd.conf
VHOSTCONFDIR=/etc/httpd/conf.vhosts.d
DEFVHOSTCONFFILE=$VHOSTCONFDIR/00-default-vhost.conf
VHOSTCONFFILE=$VHOSTCONFDIR/$VHOSTNAME.conf
WWWROOT=/srv
DEFVHOSTDOCROOT=$WWWROOT/default/www
VHOSTDOCROOT=$WWWROOT/$VHOSTNAME/www

# Check arguments
if [ "$VHOSTNAME"  = '' ] || [ "$TIER" = '' ]; then
        echo "Usage: $0 VHOSTNAME TIER"
        exit 1
else

	# Set support email address
        case $TIER in
                1)      VHOSTADMIN='basic_support@example.com'
                        ;;
                2)      VHOSTADMIN='business_support@example.com'
                        ;;
                3)      VHOSTADMIN='enterprise_support@example.com'
                        ;;
                *)      echo "Invalid tier specified."
                        exit 1
                        ;;
        esac
fi

# Create conf directory one time if non-existent
if [ ! -d $VHOSTCONFDIR ]; then
        mkdir $VHOSTCONFDIR

        if [ $? -ne 0 ]; then
                echo "ERROR: Failed creating $VHOSTCONFDIR."
                exit 1 # exit 1
        fi
fi

# Add include one time if missing
grep -q '^IncludeOptional conf\.vhosts\.d/\*\.conf$' $HTTPDCONF

if [ $? -ne 0 ]; then
        # Backup before modifying
        cp -a $HTTPDCONF $HTTPDCONF.orig

        echo "IncludeOptional conf.vhosts.d/*.conf" >> $HTTPDCONF

        if [ $? -ne 0 ]; then
                echo "ERROR: Failed adding include directive."
                exit 1
        fi
fi

cat <<DEFCONFEOF > $DEFVHOSTCONFFILE
<VirtualHost _default_:80>
  DocumentRoot $DEFVHOSTDOCROOT
  CustomLog "logs/default-vhost.log" combined
</VirtualHost>

<Directory $DEFVHOSTDOCROOT>
  Require all granted
</Directory>
DEFCONFEOF

# Check for default virtual host
if [ ! -f $DEFVHOSTCONFFILE ]; then
        cat <<DEFCONFEOF > $DEFVHOSTCONFFILE
<VirtualHost _default_:80>
  DocumentRoot $DEFVHOSTDOCROOT
  CustomLog "logs/default-vhost.log" combined
</VirtualHost>

<Directory $DEFVHOSTDOCROOT>
  Require all granted
</Directory>
DEFCONFEOF
fi

if [ ! -d $DEFVHOSTDOCROOT ]; then
        mkdir -p $DEFVHOSTDOCROOT
        restorecon -Rv /srv/
fi

cat <<CONFEOF > $VHOSTCONFFILE
<VirtualHost *:80>
  ServerName $VHOSTNAME
  ServerAdmin $VHOSTADMIN
  DocumentRoot $VHOSTDOCROOT
  ErrorLog "logs/${VHOSTNAME}_error_log"
  CustomLog "logs/${VHOSTNAME}_access_log" common
</VirtualHost>

<Directory $VHOSTDOCROOT>
  Require all granted
</Directory>
CONFEOF

# Check for virtual host conflict
if [ -f $VHOSTCONFFILE ]; then
        echo "ERROR: $VHOSTCONFFILE already exists."
        exit 1
elif [ -d $VHOSTDOCROOT ]; then
        echo "ERROR: $VHOSTDOCROOT already exists."
        exit 1
else
        cat <<CONFEOF > $VHOSTCONFFILE
<Directory $VHOSTDOCROOT>
  Require all granted
  AllowOverride None
</Directory>

<VirtualHost *:80>
  DocumentRoot $VHOSTDOCROOT
  ServerName $VHOSTNAME
  ServerAdmin $VHOSTADMIN
  ErrorLog "logs/${VHOSTNAME}_error_log"
  CustomLog "logs/${VHOSTNAME}_access_log" common
</VirtualHost>
CONFEOF

        mkdir -p $VHOSTDOCROOT
        restorecon -Rv $WWWROOT
fi

# Check config and reload
apachectl configtest &> /dev/null

if [ $? -eq 0 ]; then
        systemctl reload httpd &> /dev/null
else
        echo "ERROR: Config error."
        exit 1
fi