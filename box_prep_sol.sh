#!/bin/env bash

# Disable in.ndpd IPv6 autoconfig stuff
svcadm disable ndp

# Install prerequisite group from IPS repo
pkg set-publisher -G '*' -g https://pkg.oracle.com/solaris/beta -k /opt/apps/software/pkg.oracle.com.key.pem -c /opt/apps/software/pkg.oracle.com.certificate.pem solaris
pkg install group/prerequisite/oracle/oracle-rdbms-server-12-1-preinstall

# Prepare area for home directories
mkdir -p /opt/apps/users

# Add groups
groupadd -g 54321 dba
groupadd -g 54322 oinstall

useradd -u 54321 -g oinstall -G dba -d /opt/apps/users/grid -m grid
# Update passwd file for auto home entry (/home/grid)
# Add to /etc/auto_home:
# *       localhost:/opt/apps/users/&

# Add to grid user .profile:
# umask 022
# export ORACLE_BASE=/u01/app/grid
# export ORACLE_HOME=/u01/app/12.1.0.1/grid/
# export ORACLE_SID=+ASM1
# export TEMP=/tmp
# export TMPDIR=/tmp
# export LD_LIBRARY_PATH=$ORACLE_HOME/lib
 
export PATH=$PATH:/usr/bin:/usr/sbin:$ORACLE_HOME/bin
 
ulimit -t unlimited
ulimit -f unlimited
ulimit -d unlimited
ulimit -s unlimited
ulimit -v unlimited

# Update swap to make it at least 4.5G
zfs set volsize=4.5G rpool/swap

# Create directories for install
### mkdir -p /u01/app/grid
### mkdir -p /u01/app/12.2.0.1/grid
### Convert to ZFS
zfs create -o mountpoint=/u01/app/12.2.0.1/grid rpool/grid_home
zfs create -o mountpoint=/u01/app/grid rpool/grid_base
chown -R grid:oinstall /u01
chmod -R 775 /u01

# Set kernel tunables
projadd -G oinstall -K "project.max-shm-memory=(priv,6g,deny)" user.grid
projmod -sK "project.max-sem-nsems=(priv,512,deny)" user.grid
projmod -sK "project.max-sem-ids=(priv,128,deny)" user.grid
projmod -sK "project.max-shm-ids=(priv,128,deny)" user.grid
projmod -sK "process.max-file-descriptor=(basic,1025,deny),(priv,65536,deny)" user.grid
