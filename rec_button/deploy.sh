#!/bin/bash

ts=$(date +%s)
bkdir="$HOME/generators_backup_$ts"
mkdir $bkdir
cp /usr/local/bigbluebutton/core/lib/recordandplayback/generators/*.rb $bkdir

sudo cp ./generators/* /usr/local/bigbluebutton/core/lib/recordandplayback/generators/
