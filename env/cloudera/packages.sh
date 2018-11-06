#!/bin/bash

set -e

# Configure yum repositories

curl http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/cloudera-manager.repo > /etc/yum.repos.d/cloudera-manager.repo

rpm --import  http://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera


# Install Oracle Java 1.8
yum install -y wget unzip

cd /tmp
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.rpm"
yum localinstall jdk-8u191-linux-x64.rpm

wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip"
unzip jce_policy-8.zip

