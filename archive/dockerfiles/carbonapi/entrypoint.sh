#!/bin/sh

set -e

if [ -z "$ZIPPER" ]
then
    ZIPPER=http://localhost:8080
fi

if [ -z "GRAPHITE_HOST" ]
then
    GRAPHITE_HOST=''
fi

sed -e "s#ZIPPER#$ZIPPER#g" -i /etc/carbonapi.yaml
sed -e "s#GRAPHITE_HOST#$GRAPHITE_HOST#g" -i /etc/carbonapi.yaml


$@
