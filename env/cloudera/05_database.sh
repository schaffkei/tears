#!/bin/bash

set -e

echo "DATABASE"
rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $rundir/../functions.i.sh

if has_role database-server
then

	if [ $rundir/files/my.cnf -nt /etc/my.cnf ]
	then
		echo "Configuring MariaDB"
		systemctl stop mariadb

		cp /etc/my.cnf /tmp/my.cnf_$$
		update_file my.cnf /etc/my.cnf

		for ilog in /var/lib/mysql/ib_logfile{0,1}
		{
			if [ -e $ilog ]
			then
				mv $ilog /tmp/
			fi
		}

		systemctl enable mariadb
		systemctl start mariadb
	fi

	if ! is_completed mysql-hardened
	then
		__MRP__=$(get_sensitive mysql-root)

		if mysql -u root --password= -e "exit" 2>/dev/null
		then
			# root user has no password ==> set it
			mysql -u root --password= <<-EOSQL
				update mysql.user SET Password=PASSWORD($__MRP__) where User = 'root';
				flush privileges;
			EOSQL
		fi

		# Remove risks
		mysql -u root --password="$__MRP__" <<-EOSQL
			delete from mysql.user wher User = 'root' AND Host not in ('localhost', '127.0.0.1', '::1');
			delete from mysql.user where User = '';
			delete from mysql.db where Db = 'test' or Db = 'test_%';
			drop database if exists test;
			flush privileges;
		EOSQL

		mark_completed mysql-hardened
	fi
fi

