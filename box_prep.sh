#!/bin/env bash

# Install 12c pre-requisite package
yum install oracle-database-server-12cR2-preinstall -y

# Install updates for OEL 7.3
yum update -y
