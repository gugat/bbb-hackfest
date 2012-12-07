#!/bin/bash

ts=$(date +%s)
bkdir="$HOME/generators_backup_$ts"
mkdir $bkdir
cp /usr/local/bigbluebutton/core/lib/recordandplayback/generators/*.rb $bkdir

sudo cp ./generators/* /usr/local/bigbluebutton/core/lib/recordandplayback/generators/


RECORDING_DIR=/var/bigbluebutton/recording
WORKFLOW_NAME=recbutton

#Create directories
mkdir $RECORDING_DIR/process/$WORKFLOW_NAME
mkdir $RECORDING_DIR/publish/$WORKFLOW_NAME
mkdir /var/bigbluebutton/published/$WORKFLOW_NAME
mkdir /var/log/bigbluebutton/$WORKFLOW_NAME
mkdir /var/bigbluebutton/playback/$WORKFLOW_NAME

#Copy files
cp ./process/$WORKFLOW_NAME.rb /usr/local/bigbluebutton/core/scripts/process/$WORKFLOW_NAME.rb
cp ./publish/$WORKFLOW_NAME.rb /usr/local/bigbluebutton/core/scripts/publish/$WORKFLOW_NAME.rb
#cp ./nginx/$WORKFLOW_NAME.nginx /etc/bigbluebutton/nginx/$WORKFLOW_NAME.nginx
cp $WORKFLOW_NAME.yml /usr/local/bigbluebutton/core/scripts/$WORKFLOW_NAME.yml
#cp -r ./playback/$WORKFLOW_NAME /var/bigbluebutton/playback/

#Give permissions
chmod 755 /usr/local/bigbluebutton/core/scripts/$WORKFLOW_NAME.yml
chmod 755 /usr/local/bigbluebutton/core/scripts/process/$WORKFLOW_NAME.rb
chmod 755 /usr/local/bigbluebutton/core/scripts/publish/$WORKFLOW_NAME.rb
chown tomcat6.tomcat6 /var/bigbluebutton/recording/process/$WORKFLOW_NAME/
chown tomcat6.tomcat6 /var/bigbluebutton/recording/publish/$WORKFLOW_NAME/
chown tomcat6.tomcat6 /var/bigbluebutton/published/$WORKFLOW_NAME/
chown tomcat6.tomcat6 /var/log/bigbluebutton/$WORKFLOW_NAME
#chown tomcat6.tomcat6  -R /var/bigbluebutton/playback/$WORKFLOW_NAME/

#sudo service nginx restart
