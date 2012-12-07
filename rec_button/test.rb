require "/usr/local/bigbluebutton/core/lib/recordandplayback.rb"

#Change this meeting id
#meeting_id = "5845d2f3bebca7fc233f01871838584e69d34e5f-1350369737339"
meeting_id = "6e35e3b2778883f5db637d7a5dba0a427f692e91-1354916671428"

#Change this if you want the resultant files in other dir
target_dir = "/tmp/rb_test"


temp_dir = "/var/bigbluebutton/recording/process/slides/#{meeting_id}/temp"
Dir.glob(target_dir+"/*").each { |f| FileUtils.rm f }
Dir.glob("#{temp_dir}/#{meeting_id}/audio/audio_piece*").each{ |f| FileUtils.rm f } 
Dir.glob("#{temp_dir}/stripped*").each{ |f| FileUtils.rm f } 
Dir.glob("#{temp_dir}/piece*").each{ |f| FileUtils.rm f } 
Dir.glob("#{temp_dir}/#{meeting_id}/scaled*").each{ |f| FileUtils.rm f } 
FileUtils.mkdir_p target_dir

puts "Record Button: Testing processing of webcam"
BigBlueButton.process_webcam_rb(target_dir, temp_dir, meeting_id) 

puts "Record Button: Testing processing of desktop sharing"
BigBlueButton.process_desktop_sharing_rb(target_dir, temp_dir, meeting_id) 

#puts "Record Button: Testing processing of audio"
#BigBlueButton::AudioProcessor.process_rb("#{temp_dir}/#{meeting_id}", "#{target_dir}/audio.ogg")
