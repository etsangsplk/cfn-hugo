#!/bin/sh

source_dir=$1
target_bucket_name=$2

aws s3 sync $source_dir s3://$target_bucket_name --delete 
