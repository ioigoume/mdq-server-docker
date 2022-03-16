#!/bin/bash

ENTITYID=${ENTITYID:-https://idp.aai-dev.grnet.gr/idp/shibboleth}

sha1=`echo -n $ENTITYID  | sha1sum | awk '{print $1}'`
dir=../shared-volume
file=$dir/_$sha1.xml

if [ -d "$dir" ]; then
    if [ -f $file ]; then
        cat $file
        echo ""
    else
        echo "Entity '$ENTITYID' is unknown."
    fi
else
    echo "Directory $dir does not exist."
fi