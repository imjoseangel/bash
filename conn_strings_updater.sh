#!/usr/bin/env bash
#
# Tool:    conn_strings_updater.sh
#
# Description:
#          Shell script to change the DB connection strings in config files
#          under a given path
#
#
# Author:  J. Munoz (josea _DOT munoz _AT_ gmail _DOT_ com)
# Date:    2016-12-13
# Version: 0.1
#
#
# Requires:
# - bash
#
# Credits:
# - None
#
#
# /**************************************************************************
# *   Copyright 2016 by Jose Angel Munoz                                    *
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 3 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# *   This program is distributed in the hope that it will be useful,       *
# *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *   GNU General Public License for more details.                          *
# *                                                                         *
# *   You should have received a copy of the GNU General Public License     *
# *   along with this program. If not, see <http://www.gnu.org/licenses/>.  *
# *                                                                         *
# **************************************************************************/
#

VERSION=0.1 

echo
echo ------------------------------------------------------------
echo "           $0 - ($VERSION) "    
echo "        by Jose Munoz (josea.munoz@gmail.com)"
echo ------------------------------------------------------------
echo

# Usage first

if [ $# -lt 3 ]; then
   echo Usage: $0 RootPath BackupPath NewDataSource [OriginalDataSource]
   echo
   echo Note: If [OriginalDataSource] is not specified, all the connection strings will be updated
   echo
   exit
fi

# Variables

DATE=`date +%Y%m%d%H%M%S`

RootPath=$1
BackupPath=$2/$DATE
NewDataSource=$3
OriginalDataSource=$4


# Better to use logsave here, but we are going to use a most standard way just in case

echo "$(date) - Changing path" $RootPath "with" $NewDataSource | tee -a conn_strings_updater.log
echo
echo "$(date) - Backup available under" $BackupPath | tee -a conn_strings_updater.log
echo
echo "$(date) - Changing" $(find $RootPath -type f -iname \*.config -print0) "files" | tee -a conn_strings_updater.log
echo

# Creating new dir under BackupPath

mkdir -p $BackupPath

# Backing Up Files

echo "$(date) - Backing-Up files under" $BackupPath | tee -a conn_strings_updater.log
echo

find $RootPath -iname \*.config -exec cp {} $BackupPath \;

echo "$(date) - Changing" $OriginalDataSource "to" $NewDataSource | tee -a conn_strings_updater.log
echo

# Check if the 3rd Variable is defined and go for the change.

if [ $# -lt 4 ]; then
	find $RootPath -type f -iname \*.config -print0 | xargs -0 sed -i -e 's/Data Source=.*;Initial Catalog/Data Source='$NewDataSource';Initial Catalog/g'
else
	find $RootPath -type f -iname \*.config -print0 | xargs -0 sed -i -e 's/Source='$OriginalDataSource'/Source='$NewDataSource'/g'
fi


# End of Script