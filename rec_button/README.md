# Support for record button

## Summary

This folder contains files to support the "record button" feature in  "Record and Playback" module in a BigBlueButton server

To support the record button some generators (events.rb, audio_processor.rb, audio.rb and video.rb) needed new methods.

Those implemented methods in each generator are below a message that looks like this:

<pre>
	#########################
  	##  For record button  ##
	#########################
</pre>	


## Usage

Copy the generators 

	chmod +x deploy.sh
	./deploy.sh

Create a recorded meeting, share desktop and webcam, and write in the chat window START or STOP when you want to start or stop the recording, log out.

Check with bbb-record --watch until you can see "recbutton" under 'process' and 'publish'

Now you have two flv files, one with webcam + audio, and other only with deskshare.

## TO DO

* Create a playback for the created webcam and deskshare


* In production, when the client was implemented, comment a part of the method *get_start_and_stop_rec_events(events_xml)* in **events.rb**

	
* Use these generators and its new methods in the presentation workflow




