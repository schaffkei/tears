#!/bin/bash

set -e

rundir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source $rundir/../functions.i.sh

cmrepo=/etc/yum.repos.d/cloudera-manager.repo
if [ ! -e $cmrepo ]
then
	# Configure yum repositories
	curl http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo > $cmrepo
	rpm --import  http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
fi


if [ -z "$(ls -d /usr/java/jdk1.8*/ 2>/dev/null | head -n 1)" ]
then
	# Install Oracle Java 1.8
	yum install -y wget

	cd /tmp
	wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.rpm"
	yum localinstall jdk-8u191-linux-x64.rpm

	# It looks like Unlimited JCE is on by default
	# yum install -y unzip
	# wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip"
	# unzip jce_policy-8.zip
fi

cloudera_packages="cloudera-manager-agent"
if has_role cloudera-manager
then
	echo "Installing SCM server"
	cloudera_packages="$cloudera_packages cloudera-manager-server\*"
fi


if has_role database-server
then
	echo "Installing MariaDB"
	cloudera_packages="$cloudera_packages mariadb-server\*"
fi

eval yum install -y $cloudera_packages

