#!/usr/bin/env bash
#
# Tool:    copy_ftp.sh
#
# Description:
#          Shell script to copy all files recursively and upload them to
#          remote FTP server
#
#          If you want to use this script with netrc then make sure you
#          have file pointed by $AUTHFILE (see below) and add lines to it:
#          machine ftp.mycorp.com
#                  login myftpuser
#                  password mypassword
#          $AUTHFILE file must be unreadable by others
#
# Author:  J. Munoz (josea _DOT munoz _AT_ gmail _DOT_ com)
# Date:    2011-11-05
# Version: 1.0
#
# - Current FTP Transfers: (version 1.0)
#   FTP, SSH, SFTP
#
#
# Requires:
# - ftp
# - openssh
# http://www.openssh.com
# - expect
# http://expect.nist.gov/
#
# Credits:
# - None
#

#
# /**************************************************************************
# *   Copyright 2011 by JMunoz                                              *
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

VERSION=1.0 

echo
echo ------------------------------------------------------------
echo "    copy_ftp - ($VERSION) based on ftp and openssh"    
echo "        by Jose Munoz (josea.munoz@gmail.com)"
echo ------------------------------------------------------------

if [ -z `which sftp` ] ;then echo; echo "ERROR: sftp command not found!"; exit; fi
if [ -z `which ftp` ] ;then echo; echo "ERROR: ftp command not found!"; exit; fi
if [ -z `which expect` ] ;then echo; echo "ERROR: expect command not found!"; exit; fi	

SSHVERSION=$(ssh -V 2>&1)
EXPECTVERSION=$(expect -v)

echo + openssh version: $SSHVERSION
echo + expect version: $EXPECTVERSION
echo ------------------------------------------------------------
echo

if [ $# -lt 3 ]; then
   echo Usage: $0 HOSTNAME_or_IP PORT FTP/SSH [USER] [PASSWORD]
   echo
   exit
fi

FTPSSH=$(echo $3 | tr '[:upper:]' '[:lower:]')

if [ $FTPSSH != "ssh" -a $FTPSSH != "ftp" ]; then
   echo Usage: $0 HOSTNAME_or_IP PORT FTP/SSH [USER] [PASSWORD]
   echo
   exit
fi	 

FTP=$(which ftp)
SSH=$(which ssh)
EXPECT=$(which expect)
CMD=""
PROTOCOL="$3"
AUTHFILE=${HOME}/.netrc

case "$FTPSSH" in
	ftp) 
 
	if [ -f $AUTHFILE ] ; then
	  # use the file for auth
	  CMD="$FTP -i $1 $2"

	  $CMD <<ENDFTP
	  cd DIRECTORY
	  bin
	  ls
	  bye
ENDFTP
    exit

	else
	  echo "*** To terminate at any point hit [ CTRL + C ] ***"
	  CMD="$FTP -in $1 $2"

	  $CMD <<ENDFTP
	  user $4 $5
	  cd DIRECTORY
	  bin
	  ls
	  bye
ENDFTP
    exit

	fi
;;

ssh)

./copy_sftp.exp $1 $2 $4 $5

;;
esac