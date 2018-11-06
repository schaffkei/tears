#!/bin/bash

echo "DATABASE"
rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $rundir/../functions.i.sh

if has_role database-server && [ $rundir/files/my.cnf -nt /etc/my.cnf ]
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

