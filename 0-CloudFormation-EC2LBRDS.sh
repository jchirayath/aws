#!/bin/bash
# CloudFormation script to create VPC and Elastic Balanced Web Servers
# in a dedicating VPC
# Script runs 3-4 scripts that need to be updated individually
#
# Requires the aws CLI to be installed and keys added
#
# Add SSH key to the Account
echo "Adding SSH key .... "
read -p "Do you wish to continue?"
if [ "$REPLY" = "y" ]; then
  sh 1-AddSSHKey.sh
fi

# Sync All the S3 files
echo "Syncing S3 with local directory.... "
read -p "Do you wish to continue?"
if [ "$REPLY" = "y" ]; then
  sh 1-S3-sync.sh
fi

# Create IAM Roles
echo "Creating of IAM Roles"
read -p "Do you wish to continue?"
if [ "$REPLY" = "y" ]; then
  sh 1-CreateRole.sh
fi

# Create the VPCs and Networks
echo "Creating VPC and more .... "
read -p "Do you wish to continue?"
if [ "$REPLY" = "y" ]; then
  sh 2-Create-VPC.sh
fi

# Create the EC2 Instances with LB & RDS
echo "Creating the EC2,ELB and RDS instances ..."
read -p "Do you wish to continue?"
if [ "$REPLY" = "y" ]; then
  sh 3-Create-EC2.sh
fi

# Done
echo "Done with scripts !!!! "