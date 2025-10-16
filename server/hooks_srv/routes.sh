#!/usr/bin/env bash
set -e
HOST=$(hostname)
BACKUP_PATH=/opt/backup/routes
BACKUP_FILE=$HOST-routes
helpcli() {
echo "--backup  | Save Network routes"
echo "--restore | Restore Network routes"
}
backup() {
  if [ ! -d "/opt/backup" ]; then
    mkdir /opt/backup
  else
    echo "backup already exists"
fi

  if [ ! -d "/opt/backup/routes" ]; then
    mkdir /opt/backup/routes
  else
    echo "routes already exists"
fi

  if [ -f $BACKUP_PATH/$BACKUP_FILE ]; then 
    rm -rf $BACKUP_PATH/$BACKUP_FILE
    /usr/sbin/ip r save > $BACKUP_PATH/$BACKUP_FILE
  else
    /usr/sbin/ip r save > $BACKUP_PATH/$BACKUP_FILE
fi
  exit 0
}

restore() {
/usr/sbin/ip r restore < $BACKUP_PATH/$BACKUP_FILE 
exit 0
}

while [ -n "$1" ]
	do
    case "$1" in
    --backup )backup;;
    --restore )restore;;
	  --help )helpcli;;
	  * )helpcli;;
    esac
	shift
done
