#!/usr/bin/env bash

set -e

file=$1
reset=$2

name=$(kubectl get -f $file -ojsonpath='.metadata.name' --ignore-not-found=true)

echo "Appling from $file if needed..."

if [ -z $name ]; then
    kubectl apply -f $file
elif [ "$reset" = "true" ]; then
    kubectl delete -f $file
    kubectl apply -f $file
fi
