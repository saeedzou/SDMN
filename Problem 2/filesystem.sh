#!/bin/bash
if [ ! -f ubuntu-focal-oci-amd64-root.tar.gz ]
then
    curl -O https://partner-images.canonical.com/oci/focal/current/ubuntu-focal-oci-amd64-root.tar.gz
fi
if [ -d "./ubuntu_fs" ] 
then
    tar -xf ubuntu-focal-oci-amd64-root.tar.gz -C ./ubuntu_fs
else
    mkdir ubuntu_fs
    tar -xf ubuntu-focal-oci-amd64-root.tar.gz -C ./ubuntu_fs
fi

if [ $# -eq 1 ]
then
    go run main.go run $1
else
    go run main.go run $1 $2 $3
fi