#!/bin/env bash

# Install 12c pre-requisite package
yum install oracle-database-server-12cR2-preinstall -y

# Install updates for OEL 7.3
yum update -y

# Add additional packages
yum install binutils -y
yum install compat-libstdc++-33 -y
yum install compat-libstdc++-33.i686 -y
yum install gcc -y
yum install gcc-c++ -y
yum install glibc -y
yum install glibc.i686 -y
yum install glibc-devel -y
yum install glibc-devel.i686 -y
yum install ksh -y
yum install libgcc -y
yum install libgcc.i686 -y
yum install libstdc++ -y
yum install libstdc++.i686 -y
yum install libstdc++-devel -y
yum install libstdc++-devel.i686 -y
yum install libaio -y
yum install libaio.i686 -y
yum install libaio-devel -y
yum install libaio-devel.i686 -y
yum install libXext -y
yum install libXext.i686 -y
yum install libXtst -y
yum install libXtst.i686 -y
yum install libX11 -y
yum install libX11.i686 -y
yum install libXau -y
yum install libXau.i686 -y
yum install libxcb -y
yum install libxcb.i686 -y
yum install libXi -y
yum install libXi.i686 -y
yum install make -y
yum install sysstat -y
yum install unixODBC -y
yum install unixODBC-devel -y
yum install zlib-devel -y
yum install zlib-devel.i686 -y

# Add some group information
groupadd -g 54321 oinstall
groupadd -g 54322 dba
groupadd -g 54323 oper
#groupadd -g 54324 backupdba
#groupadd -g 54325 dgdba
#groupadd -g 54326 kmdba
#groupadd -g 54327 asmdba
#groupadd -g 54328 asmoper
#groupadd -g 54329 asmadmin
#groupadd -g 54330 racdba

useradd -u 54321 -g oinstall -G dba,oper oracle

# Set the oracle password
#passwd oracle

# Consider disabling libvirtd to make dnsmasq work
# Make sure local IP address is configured for DNS on the interface
# Make sure the IP addresses are entered in the /etc/hosts file
systemctl disable libvirtd
systemctl stop libvirtd
systemctl kill libvirtd # (probably needed)
systemctl enable dnsmasq
systemctl start dnsmasq

# Change SELinux to permissive
sed -r -i.bak -e s/SELINUX=enforcing/SELINUX=permissive/g /etc/selinux/config

# Stop and disable the firewall
systemctl stop firewalld
systemctl disable firewalld

# Create the directories for the software install
mkdir -p /u01/app/grid/product/12.2.0.1
mkdir -p /u01/app/oracle/product/12.2.0.1/db_1
chown -R oracle:oinstall /u01
chmod -R 775 /u01/
