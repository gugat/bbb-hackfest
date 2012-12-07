# Set encoding to utf-8
# encoding: UTF-8
#
# BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
#
# Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
#

require '../../core/lib/recordandplayback'
require 'rubygems'
require 'trollop'
require 'yaml'
require 'builder'

opts = Trollop::options do
  opt :meeting_id, "Meeting id to archive", :default => '58f4a6b3-cd07-444d-8564-59116cb53974', :type => String
end

meeting_id = opts[:meeting_id]
puts meeting_id
match = /(.*)-(.*)/.match meeting_id
meeting_id = match[1]
playback = match[2]

puts meeting_id
puts playback

bbb_props = YAML::load(File.open('../../core/scripts/bigbluebutton.yml'))
recbutton_props = YAML::load(File.open('recbutton.yml'))
recording_dir = bbb_props['recording_dir']


if (playback == "recbutton")
	logger = Logger.new("/var/log/bigbluebutton/recbutton/publish-#{meeting_id}.log", 'daily' )
	BigBlueButton.logger = logger
    BigBlueButton.logger.info("Publishing #{meeting_id}")
	
	process_dir = "#{recording_dir}/process/recbutton/#{meeting_id}"
	publish_dir = recbutton_props['publish_dir']
	playback_host = bbb_props['playback_host']
	

	target_dir = "#{recording_dir}/publish/recbutton/#{meeting_id}"
	if not FileTest.directory?(target_dir)
	  FileUtils.mkdir_p target_dir
	end
		
	video = "#{process_dir}/muxed-audio-webcam.flv"		
	deskshare = "#{process_dir}/deskshare.flv"		
	package_dir = "#{target_dir}/#{meeting_id}"
	FileUtils.mkdir_p package_dir
	FileUtils.cp(video, package_dir)

    BigBlueButton.logger.info("Creating metadata.xml")
    # Create metadata.xml
    b = Builder::XmlMarkup.new(:indent => 2)
    metaxml = b.recording {
      b.id(meeting_id)
      b.state("available")
      b.published(true)
      # Date Format for recordings: Thu Mar 04 14:05:56 UTC 2010
      b.start_time(BigBlueButton::Events.first_event_timestamp("#{process_dir}/events.xml"))
      b.end_time(BigBlueButton::Events.last_event_timestamp("#{process_dir}/events.xml"))
      b.playback {
        b.format("recbutton")
        b.link("http://#{playback_host}/playback/recbutton/playback.html?meetingId=#{meeting_id}")        
      }
      b.meta {
        BigBlueButton::Events.get_meeting_metadata("#{process_dir}/events.xml").each { |k,v| b.method_missing(k,v) }
      }      
    }
    metadata_xml = File.new("#{package_dir}/metadata.xml","w")
    metadata_xml.write(metaxml)
    metadata_xml.close

    BigBlueButton.logger.info("Publishing video")
    
    # Now publish this recording	
    if not FileTest.directory?(publish_dir)
  		FileUtils.mkdir_p publish_dir
    end
    
    FileUtils.cp_r(package_dir, publish_dir)			
end
