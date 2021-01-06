# MySQL Backup Script #

The entire setup consists of 2 files:

- mysql-backup.conf: This is the configuration file containing the 
- mysql-backup.sh: This is the actual script. DO NOT MODIFY THIS.

This requires a MySQL account with SELECT and LOCK TABLES privileges to the
databases to be backed up. If your databases have views and events, the
SHOW VIEW and EVENT privileges is also necessary.

## MySQL Backup Account ##

Use the following SQL, replacing the 'backups' and 'password' with the desired
backup account:

	CREATE USER 'backups'@'localhost' IDENTIFIED BY 'password';

Then grant the required privileges to all databases:

	GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT on *.* to 'backups'@'localhost';

## Setup/Installation ##

Create a directory where the scripts and backups will be located. For example:

	mkdir -p /home/mysql-backup/mysql-backup/BACKUPS

Copy the sample configuration to /home/mysql-backup/mysql-backup:

	cp mysql-backup.conf.sample /home/mysql-backup/mysql-backup/mysql-backup.conf

Edit the configuration file mysql-backup.conf. The important variables to change
are:

- USERNAME: Set to the username created above.
- PASSWORD: Set to the password of the username created above.
- BACKUPDIR: Set to the desired backup location. If the example was followed, it
  should be /home/mysql-backup/mysql-backup/BACKUPS

Then list the databases to be backed up in the respective variables, separated
by spaces.

- DBLIST: This list will be backed up with the current date appended to the
  filename.
- DBLIST_NODATE: This list will be backed up, keeping only the previous backup.

So, if you wish to have dated backups "important1" and "important2", and
non-dated backups of "logs1" and "logs2" the variables would be:

	DBLIST="important1 important2"
	DBLIST_NODATE="logs1 logs2"

## Cron ##

To schedule the backup automatically, `crontab -e` and and a schedule to run the
backup script. For example:

	00 03 * * *	    /home/mysql-backup/mysql-backup/mysql-backup.sh

The sample above is scheduled to run the script at 10pm, Monday to Friday.

### Remove old backups ###

Backups will quickly pile up with this script. If you wish to remove older
backups automatically, you can use the following commands to clear out backups
older than a certain number of days (command below is set to 30 days).

Change the "atime" parameter to your preferred number of days. Follow your
Privacy Policy regarding data retention in backups.

Remember to change the directory as well if you are using a different directory.

**THIS WILL DELETE FILES SO USE WITH CAUTION**.

	00 14 * * *	    find /home/mysql-backup/mysql-backup/BACKUPS/ -depth -type f -atime +30 -delete
