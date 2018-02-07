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
groupadd -g 54323 asmadmin
groupadd -g 54324 oper
groupadd -g 54326 asmoper
groupadd -g 54327 asmdba

useradd -u 54321 -g oinstall -G dba,asmadmin,asmoper,asmdba -d /opt/apps/users/grid -m grid
useradd -u 54322 -g oinstall -G dba,asmdba -d /opt/apps/users/oracle -m oracle
# Update passwd file for auto home entry (/home/grid)
# Add to /etc/auto_home:
# *       localhost:/opt/apps/users/&

# Add to grid user .profile:
cat << EOF >> ~grid/.profile

umask 022
export ORACLE_BASE=/u01/app/grid
export ORACLE_HOME=/u01/app/12.2.0.1/grid/
export ORACLE_SID=+ASM1
export TEMP=/tmp
export TMPDIR=/tmp
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
 
export PATH=$PATH:/usr/bin:/usr/sbin:$ORACLE_HOME/bin

export OH=${ORACLE_HOME}
export OB=${ORACLE_BASE}

alias oh='cd ${OH}'
alias ob='cd ${OB}'
 
ulimit -t unlimited
ulimit -f unlimited
ulimit -d unlimited
ulimit -s unlimited
ulimit -v unlimited
EOF

# Update swap to make it at least 4.5G
zfs set volsize=4.5G rpool/swap

# Create directories for install
### mkdir -p /u01/app/grid
### mkdir -p /u01/app/12.2.0.1/grid
### Convert to ZFS
zfs create -o mountpoint=/u01/app/12.2.0.1/grid rpool/grid_home
zfs create -o mountpoint=/u01/app/grid rpool/grid_base
zfs create -o mountpoint=/u01/app/oracle rpool/oracle_base
chown -R grid:oinstall /u01
chown oracle:oinstall /u01/app/oracle
chmod -R 775 /u01

# Set kernel tunables
projadd -G oinstall -K "project.max-shm-memory=(priv,6g,deny)" user.grid
projmod -sK "project.max-sem-nsems=(priv,512,deny)" user.grid
projmod -sK "project.max-sem-ids=(priv,128,deny)" user.grid
projmod -sK "project.max-shm-ids=(priv,128,deny)" user.grid
projmod -sK "process.max-file-descriptor=(basic,1025,deny),(priv,65536,deny)" user.grid

# 12.2 GA requires SCAN address to resolve in DNS.  Install dnsmasq to do this.
pkg install dnsmasq
# Add localhost to /etc/resolv.conf
# nameserver 127.0.0.1
# Enable dnsmasq
svcadm enable dnsmasq
