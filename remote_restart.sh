#!/bin/bash

HOST=$BT_DROPLET_IP
DEST_USER=root
SVC=nginx
ssh $DEST_USER@$HOST "systemctl stop $SVC && sleep 1 && systemctl start $SVC; echo 'Restarted $SVC'"
echo 'Restarted nginx'
echo 'Done'
