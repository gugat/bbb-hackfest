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

opts = Trollop::options do
  opt :meeting_id, "Meeting id to archive", :default => '58f4a6b3-cd07-444d-8564-59116cb53974', :type => String
end

meeting_id = opts[:meeting_id]

#Matterhorn process log file
logger = Logger.new("/var/log/bigbluebutton/recbutton/process-#{meeting_id}.log", 'daily' )
BigBlueButton.logger = logger

# This script lives in scripts/archive/steps while bigbluebutton.yml lives in scripts/
bbb_props = YAML::load(File.open('../../core/scripts/bigbluebutton.yml'))
recbutton_props = YAML::load(File.open('recbutton.yml'))

recording_dir = bbb_props['recording_dir']
raw_archive_dir = "#{recording_dir}/raw/#{meeting_id}"
target_dir = "#{recording_dir}/process/recbutton/#{meeting_id}"

if not FileTest.directory?(target_dir)	  
	FileUtils.mkdir_p target_dir

        temp_dir = "#{target_dir}/temp"
        FileUtils.mkdir_p temp_dir
        FileUtils.cp_r(raw_archive_dir, temp_dir)
        events_xml = "#{temp_dir}/#{meeting_id}/events.xml"
        FileUtils.cp(events_xml, target_dir)

	if  !Dir["#{raw_archive_dir}/audio/*"].empty?
	  BigBlueButton.process_webcam_rb(target_dir, temp_dir, meeting_id)
	end

	if  !Dir["#{raw_archive_dir}/deskshare/*"].empty?
          BigBlueButton.process_desktop_sharing_rb(target_dir, temp_dir, meeting_id)
        end

	process_done = File.new("#{recording_dir}/status/processed/#{meeting_id}-recbutton.done", "w")
	process_done.write("Processed #{meeting_id}")
	process_done.close
end


