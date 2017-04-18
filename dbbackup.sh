#!/bin/bash

# Variables
DBUSER=root
FMTOPTIONS='--skip-column-names -E'
COMMAND='SHOW DATABASES'
BACKUPDIR=/dbbackup

# Backup non-system databases
for DBNAME in $(mysql $FMTOPTIONS -u $DBUSER -e "$COMMAND" | grep -v ^* | grep -v information_schema | grep -v performance_schema); do
echo "Backing up \"$DBNAME\""
  mysqldump -u $DBUSER $DBNAME > $BACKUPDIR/$DBNAME.dump
done

# Add up size of all database dumps
for DBDUMP in $BACKUPDIR/*; do
  SIZE=$(stat --printf "%s\n" $DBDUMP)
  TOTAL=$[ $TOTAL + $SIZE ]
done

# Report name, size, and percentage of total for each database dump
echo
for DBDUMP in $BACKUPDIR/*; do
  SIZE=$(stat --printf "%s\n" $DBDUMP)
  echo "$DBDUMP,$SIZE,$[ 100 * $SIZE / $TOTAL ]%"
done