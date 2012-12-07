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


require 'fileutils'

module BigBlueButton
  class AudioProcessor
    # Process the raw recorded audio to ogg file.
    #   archive_dir - directory location of the raw archives. Assumes there is audio file and events.xml present.
    #   ogg_file - the file name of the ogg audio output
    #
    def self.process(archive_dir, ogg_file)
      audio_dir = "#{archive_dir}/audio"
      events_xml = "#{archive_dir}/events.xml"
      audio_events = BigBlueButton::AudioEvents.process_events(audio_dir, events_xml)
      audio_files = []
      audio_events.each do |ae|
        if ae.padding 
          ae.file = "#{audio_dir}/#{ae.length_of_gap}.wav"
          BigBlueButton::AudioEvents.generate_silence(ae.length_of_gap, ae.file, 16000)
        else
          # Substitute the original file location with the archive location
          ae.file = ae.file.sub(/.+\//, "#{audio_dir}/")
        end
        
        audio_files << ae.file
      end
      
      wav_file = "#{audio_dir}/recording.wav"
      BigBlueButton::AudioEvents.concatenate_audio_files(audio_files, wav_file)    
      BigBlueButton::AudioEvents.wav_to_ogg(wav_file, ogg_file)
    end
	
	#########################
    ##  For record button  ##
	#########################
	
	# Process the raw recorded audio to ogg file, according to the record button.
    #   archive_dir - directory location of the raw archives. Assumes there is audio file and events.xml present.
    #   ogg_file - the file name of the ogg audio output
    #
    def self.process_rb(archive_dir, ogg_file)
      audio_dir = "#{archive_dir}/audio"
      events_xml = "#{archive_dir}/events.xml"
      audio_events = BigBlueButton::AudioEvents.process_events(audio_dir, events_xml)      
      audio_files = []
      audio_events.each do |ae|
        if ae.padding 
          ae.file = "#{audio_dir}/#{ae.length_of_gap}.wav"
          BigBlueButton::AudioEvents.generate_silence(ae.length_of_gap, ae.file, 16000)
        else
          # Substitute the original file location with the archive location
          ae.file = ae.file.sub(/.+\//, "#{audio_dir}/")
        end
        
        audio_files << ae.file
      end
      
      wav_file = "#{audio_dir}/prerecording.wav"
      BigBlueButton::AudioEvents.concatenate_audio_files(audio_files, wav_file)   

      rec_events = BigBlueButton::Events.get_start_and_stop_rec_events(events_xml)

 #=begin      
      if rec_events.empty?
        #There is not usage of recording button          
        BigBlueButton::AudioEvents.wav_to_ogg(wav_file, ogg_file)
      else
        #If record button is used then trim audio in desired recorded periods
        matched_rec_evts =  BigBlueButton::Events.match_start_and_stop_rec_events(rec_events)          
        record_started =  audio_events[0].start_record_timestamp
        audio_pieces = []  
        final_wav_file = "#{audio_dir}/recording.wav"
        matched_rec_evts.each_with_index do |evt,i|
      		piece_start_sec = BigBlueButton.relative_secs(record_started, evt[:start_timestamp])
      		piece_stop_sec = BigBlueButton.relative_secs(record_started, evt[:stop_timestamp])
      		audio_piece_name = "#{audio_dir}/audio_piece_#{i}.wav"
      		BigBlueButton::AudioEvents.trim_audio_rb(wav_file, audio_piece_name, piece_start_sec, piece_stop_sec) 
    	    audio_pieces << audio_piece_name
    	  end
      	BigBlueButton::AudioEvents.concatenate_audio_files(audio_pieces, final_wav_file)   	 
        BigBlueButton::AudioEvents.wav_to_ogg(final_wav_file, ogg_file)
      end
#=end      
    end
	
	
  end
end