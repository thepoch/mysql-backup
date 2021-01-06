#!/bin/sh
#
# Script that uses mysqldump to backup MySQL databases.
# NOTE: This requires a user with the following minimum privileges
# for backing up:
#  - SELECT
#  - LOCK TABLES
#  - SHOW VIEW (if you use views)
#  - EVENT (if you use events)

# Configuration file that contains USERNAME, PASSWORD, BACKUPDIR,
# DBLIST, and DBLIST_NODATE.
CONFIG=`dirname $0`/mysql-backup.conf
if [ -f $CONFIG ]; then
	. $CONFIG
else
	echo "ERROR: Configuration file not found."
	exit 1
fi

# Today in YYYYMMDD format.
TODAY=`date +%Y-%m-%d-%H-%M-%S`

# Create the BACKUPDIR if it doesn't exist.
if [ ! -d "$BACKUPDIR" ]; then
	mkdir -pv "$BACKUPDIR"
fi

# Let's go to the BACKUPDIR.
cd $BACKUPDIR

# Backup process - DATE
#
for DATABASE in $DBLIST; do
	mysqldump -h $HOSTNAME -u $USERNAME --password=$PASSWORD --routines --events $DATABASE > $DATABASE-$TODAY.sql
	gzip $DATABASE-$TODAY.sql
done

# Backup process - NODATE
#
for DATABASE in $DBLIST_NODATE; do
	if [ -f $DATABASE-current.tar.gz ]; then
		mv $DATABASE-current.tar.gz $DATABASE-previous.tar.gz
	fi
	mysqldump -h $HOSTNAME -u $USERNAME --password=$PASSWORD --routines --events $DATABASE > $DATABASE-$TODAY.sql
	gzip $DATABASE-$TODAY.sql
done
