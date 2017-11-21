#!/bin/bash

#Init script parameters
machineName="<%=@hostname %>"
datacentre="<%=@datacentre %>"
type="<%=@backup_type %>"
date=$(date "+%F")
tempDest="<%=@backup_destination %>"
backupFile="$tempDest/$machineName-$type-$date.tar.gz"

#blob storage account variables
storageAccountName="<%=@storage_account_name %>"
storageAccountKey="<%=@storage_account_key %>"
storageContainer="<%=@storage_account_container %>"
backup_send="<%=@externalbackup_folder %>/zabbix_state_send.txt"

sendMessageSlack ()
{
PAYLOAD='payload={"channel": "<%=@slack_channel %>", "username": "'"$datacentre"'", "icon_emoji": ":ghost:", "text": "'
PAYLOAD="$PAYLOAD $backuplog \" }"

echo "$PAYLOAD"

curl -X POST --data-urlencode "$PAYLOAD" replaceme
}

# Remove if a backup tar.gz already exists.
file="$tempDest/$machineName-$type-*.tar.gz"
rm -rf $file

#Check backup destination.
if [ ! -d "$tempDest" ]; then
       mkdir -p $tempDest
fi

#Compress all the files with all the patterns.
tar -Pczpvf $backupFile<% if ! @backup_exclude.empty? -%><% @backup_exclude.each do |exclude| -%> --exclude='<%= exclude %>'<% end -%><% end -%>
<% @source_files.each do |source| -%>
<% if ! @patterns.empty? -%><% @patterns.each do |pattern| -%> $(ls -t <%= source %>/* | grep <%= pattern %> <% if @backup_latest == true -%>| head -1<% end -%>)<% end -%>
<% else -%> $(ls -t <%= source %>/* <% if @backup_latest == true -%>| head -1<% end -%>)<% end -%>
<% end -%>

#Upload to blob storage.
. /etc/profile.d/nvm.sh
info=`azure storage blob upload -a $storageAccountName --container $storageContainer -k $storageAccountKey $backupFile`

size=`echo $info | grep -Po 'contentLength \K[^ ]*'`
success=`echo $info | grep -c "OK"`

<% if @zabbix_server != 'undef' -%>

# zabbix sender parameters.
touch $backup_send
:> $backup_send
fqdn=`hostname -f`

echo "$fqdn backup.size $size" >> $backup_send
echo "$fqdn backup.success $success" >> $backup_send
zabbix_sender -z <%= @zabbix_server %> -i $backup_send

<% end -%>

# slack message
backuplog=`echo "
*###### $datacentre ######*
*Backup done and uploaded to blob storage:*
*Hostname:* $machineName
*Backup File:* $(ls -1 $backupFile)
*Uploaded to:* *Storage Acount:* $storageAccountName *Storage Container:* $storageContainer
*MD5:* $(md5sum $backupFile | awk '{print $1}')
*Size:* $size
*Success:* $success

##################################################################"`

echo -e $backuplog

sendMessageSlack $datacentre $backuplog

echo "all done!"
