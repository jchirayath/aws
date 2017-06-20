#!/bin/bash
# CloudFormation script to create VPC and Elastic Balanced Web Servers
# in a dedicating VPC
# Script runs 3-4 scripts that need to be updated individually
#
# Requires the aws CLI to be installed and keys added
#
# Add SSH key to the Account
1-AddSSHKey.sh
# Create IAM Roles
1-CreateRole.sh
# Sync All the S3 files
1-S3-sync.sh
# Create the VPCs and Networks
2-Create-VPC.sh
# Create the EC2 Instances with LB & RDS
3-Create-EC2.sh