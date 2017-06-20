#!/bin/bash
# Sync files with S3
# Pull all the files first
aws s3 sync s3://jchirayath/  s3
# Push all the files now
aws s3 sync s3 s3://jchirayath/ 
