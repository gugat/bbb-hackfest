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


require 'rubygems'
require 'streamio-ffmpeg'

module BigBlueButton
  # Strips the audio stream from the video file
  #   video_in - the FLV file that needs to be stripped of audio
  #   video_out - the resulting FLV with the audio stripped
  # Example:
  #    strip_audio_from_video(orig-video.flv, video2.flv)
  def self.strip_audio_from_video(video_in, video_out)
    BigBlueButton.logger.info("Task: Stripping audio from video")      
    command = "ffmpeg -i #{video_in} -loglevel fatal -an -vcodec copy #{video_out}"
    BigBlueButton.execute(command)
    # TODO: check for result, raise an exception when there is an error
  end
  
  # Generates a new video file given a start point and a duration
  #   start - start point of the video_in, in milisseconds
  #   duration - duration of the new video file, in milisseconds
  #   video_in - the video to be used as base
  #   video_out - the resulting new video
  def self.trim_video(start, duration, video_in, video_out)
    BigBlueButton.logger.info("Task: Trimming video")
    
=begin
    command = "ffmpeg -i #{video_in} -loglevel fatal -vcodec copy -acodec copy -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} #{video_out}"
    #Good quality
    #Videos are shorter
    #They start after I want, a part at the beginning is trimmed.

    command = "ffmpeg -ss #{BigBlueButton.ms_to_strtime(start)} -i #{video_in} -loglevel fatal -vcodec copy -acodec copy  -t #{BigBlueButton.ms_to_strtime(duration)} #{video_out}"
    command = "ffmpeg -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} -i #{video_in} -loglevel fatal -vcodec copy -acodec copy   #{video_out}"
    #Good quality
    #Videos are shorter
    #They start before I want, a part at the beginning is extra. 
    
    #Usando como codec flv
    command = "ffmpeg -i #{video_in} -loglevel fatal -vcodec flv -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} #{video_out}"
    #Cambiando bitrate
    command = "ffmpeg -i #{video_in} -loglevel fatal -vcodec flv -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} -b:v 400k #{video_out}"
    #Poniendo el bitrate antes del codec
    command = "ffmpeg -i #{video_in} -loglevel fatal -b:v 400k -vcodec flv -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)}  #{video_out}"
    command = "ffmpeg -i #{video_in} -loglevel fatal -b:v 400k -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)}  #{video_out}"
    #Bad quality
    #Correct size
    #command = "ffmpeg -i #{video_in} -loglevel fatal -vcodec flv -acodec copy -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} #{video_out}"
    #Bad quality + correct size

    #command = "ffmpeg -ss #{BigBlueButton.ms_to_strtime(start)} -i #{video_in} -loglevel fatal -vcodec copy -acodec copy  -t #{BigBlueButton.ms_to_strtime(duration)} #{video_out}"
    
    
    #command = "ffmpeg -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} -i #{video_in} -loglevel fatal -vcodec copy -acodec copy  #{video_out}"
    #Video is delayed and has some extra content at the beginning

    #command = "ffmpeg -i #{video_in} -loglevel fatal -ss #{BigBlueButton.ms_to_strtime(start)} -t #{BigBlueButton.ms_to_strtime(duration)} #{video_out}"
    #bad quality + correct size 
=end
    command = "ffmpeg -i #{video_in} -loglevel fatal -vcodec copy -ss #{BigBlueButton.ms_to_strtime(start-1309.5)} -t #{BigBlueButton.ms_to_strtime(duration)}  #{video_out}"
    #between 1309 y 1310

   
    BigBlueButton.execute(command)  
    # TODO: check for result, raise an exception when there is an error
  end


  # Create a blank video using Flash Screen Video codec of specific length
  #   length - length of blank video in seconds
  #   rate - the frame rate of the video
  #   blank_canvas - an image (JPG) used to generate the video frames
  #   video_out - the resulting blank video file
  #  Example:
  #   create_blank_video(15, 1000, canvas.jpg, blank-video.flv)
  def self.create_blank_deskshare_video(length, rate, blank_canvas, video_out)
    BigBlueButton.logger.info("Task: Creating blank deskshare video")      
    loop_param = (`ffmpeg -version | grep ffmpeg | cut -d ' ' -f3`).chomp.eql?("0.11.2") ? "-loop 1" : "-loop_input"
    command = "ffmpeg #{loop_param} -t #{length} -i #{blank_canvas} -loglevel fatal -v -10 -r #{rate} -vcodec flashsv #{video_out}"
    BigBlueButton.execute(command)
    # TODO: check for result, raise exception when there is an error
  end

  # Create a blank video of specific length
  #   length - length of blank video in seconds
  #   rate - the frame rate of the video
  #   blank_canvas - an image (JPG) used to generate the video frames
  #   video_out - the resulting blank video file
  #  Example:
  #   create_blank_video(15, 1000, canvas.jpg, blank-video.flv)
  def self.create_blank_video(length, rate, blank_canvas, video_out)
    BigBlueButton.logger.info("Task: Creating blank video")      
    loop_param = (`ffmpeg -version | grep ffmpeg | cut -d ' ' -f3`).chomp.eql?("0.11.2") ? "-loop 1" : "-loop_input"
    command = "ffmpeg -y #{loop_param} -t #{length} -i #{blank_canvas} -loglevel fatal -v -10 -r #{rate} #{video_out}"
    BigBlueButton.execute(command)
    # TODO: check for result, raise exception when there is an error
  end
  
  def self.create_blank_video_ms(length, rate, blank_canvas, video_out)
    BigBlueButton.create_blank_video(BigBlueButton.ms_to_strtime(length), rate, blank_canvas, video_out)
  end

  # Creates a blank image file with the specified dimension and color
  #   width - the width of the image
  #   height - the height of the image
  #   color - the color of the image
  #   out_file - the file of the resulting image
  # Example:
  #   create_blank_canvas(1280, 720, white, blank_canvas.jpg)
  def self.create_blank_canvas(width, height, color, out_file)
    BigBlueButton.logger.info("Task: Creating blank canvas")      
    command = "convert -size #{width}x#{height} xc:#{color} #{out_file}"
    BigBlueButton.execute(command)
    # TODO: check for result, raise an exception when there is an error
  end

  # Concatenates several videos into one video
  #   videos_in - an array of videos that need to be concatenated. The videos
  #               will be concatenated based on their order in the array.
  #   video_out - the concatenated video
  #                
  def self.concatenate_videos(videos_in, video_out)
    BigBlueButton.logger.info("Task: Concatenating videos")      
    # This command hangs.
    #command = "mencoder -forceidx -of lavf -oac copy -ovc copy -o #{video_out} #{videos_in.join(' ')}"
    #BigBlueButton.execute(command)
    # Somehow, using the backtick works but not using popen.
    #BigBlueButton.logger.info("mencoder -forceidx -of lavf -oac copy -ovc copy -o #{video_out} #{videos_in.join(' ')}")
    #`mencoder -forceidx -of lavf -oac copy -ovc copy -o #{video_out} #{videos_in.join(' ')}`
    #Converting .flv input videos to .mpg and then concatenating them also works using popen.
   
    #Create .mpg files
    mpgs = []
    videos_in.each do |flv|
        if File.extname(flv) == ".mpg"
            mpg = flv
        else
            mpg = "#{flv}.mpg"
            BigBlueButton.convert_flv_to_mpg(flv,mpg)
        end
        mpgs << mpg
    end
    
	target_dir = File.dirname("#{video_out}")

	#Concatenate mpg files
	BigBlueButton.concatenate_mpg_files(mpgs,"#{target_dir}/concatenated.mpg")
    
	#Convert mpg to flv
	BigBlueButton.convert_mpg_to_flv("#{target_dir}/concatenated.mpg", video_out)

  end

  #Converts flv to mpg
  def self.convert_flv_to_mpg(flv_video, mpg_video_out)
        command = "ffmpeg -i #{flv_video} -loglevel fatal -v -10 -f mpegts -r 29.97 #{mpg_video_out}"        
        BigBlueButton.logger.info("Task: Converting .flv to .mpg")    
        BigBlueButton.execute(command)
  end

  #Concatenates mpg files
  def self.concatenate_mpg_files(videos_in, mpg_video_out)        
  	command = "cat #{videos_in.join(' ')} >  #{mpg_video_out}"
        BigBlueButton.logger.info("Task: Concatenating .mpg files")
        BigBlueButton.execute(command);
  end

  #Converts .mpg to .flv
  def self.convert_mpg_to_flv(mpg_video,flv_video_out)
        command = "ffmpeg -i  #{mpg_video} -loglevel fatal -v -10  #{flv_video_out}"
        BigBlueButton.logger.info("Task: Converting .mpg to .flv")
        BigBlueButton.execute(command);
  end


  # Multiplexes an audio and video
  #  audio - the audio file
  #  video - the video file. Must not contain an audio stream. 
  def self.multiplex_audio_and_video(audio, video, video_out)
    BigBlueButton.logger.info("Task: Multiplexing audio and video")      
    command = "ffmpeg -i #{audio} -i #{video} -loglevel fatal -v -10 -map 1:0 -map 0:0 -ar 22050 #{video_out}"
    BigBlueButton.execute(command)
    # TODO: check result, raise an exception when there is an error
  end

  
  # Determine the video padding we need to generate.
  def self.generate_video_paddings(events, first_timestamp, last_timestamp)
    BigBlueButton.logger.info("Task: Generating video paddings")      
    paddings = []
    events.sort! {|a,b| a[:start_timestamp] <=> b[:start_timestamp]}
        
    length_of_gap = events[0][:start_timestamp] - first_timestamp
    if  (length_of_gap > 0)
      paddings << {:start_timestamp => first_timestamp, :stop_timestamp => events[0][:start_timestamp] - 1, :gap => true, :stream => "blank-beginning.flv"}
    end
        
    i = 0
    while i < events.length - 1
      ar_prev = events[i]
      ar_next = events[i+1]
      length_of_gap = ar_next[:start_timestamp] - ar_prev[:stop_timestamp]
          
      if (length_of_gap > 0) 
        paddings << {:start_timestamp => ar_prev[:stop_timestamp] + 1, :stop_timestamp => ar_next[:start_timestamp] - 1, :gap => true, :stream => "blank-#{i}.flv"}
      end
          
      i += 1
    end
        
    length_of_gap = last_timestamp - events[-1][:stop_timestamp]
    if (length_of_gap > 0)
      paddings << {:start_timestamp => events[-1][:stop_timestamp] + 1, :stop_timestamp => last_timestamp - 1, :gap => true, :stream => "blank-end.flv"}
    end
        
    paddings
  end

  # Determine the deskshare padding we need to generate.
  def self.generate_deskshare_paddings(events, first_timestamp, last_timestamp)
    BigBlueButton.logger.info("Task: Generating deskshare paddings")      
    paddings = []
    events.sort! {|a,b| a[:start_timestamp] <=> b[:start_timestamp]}
        
    length_of_gap = events[0][:start_timestamp] - first_timestamp
    if  (length_of_gap > 0)
      paddings << {:start_timestamp => first_timestamp, :stop_timestamp => events[0][:start_timestamp] - 1, :gap => true, :stream => "ds-blank-beginning.flv"}
    end
        
    i = 0
    while i < events.length - 1
      ar_prev = events[i]
      ar_next = events[i+1]
      length_of_gap = ar_next[:start_timestamp] - ar_prev[:stop_timestamp]
          
      if (length_of_gap > 0) 
        paddings << {:start_timestamp => ar_prev[:stop_timestamp] + 1, :stop_timestamp => ar_next[:start_timestamp] - 1, :gap => true, :stream => "ds-blank-#{i}.flv"}
      end
          
      i += 1
    end
        
    length_of_gap = last_timestamp - events[-1][:stop_timestamp]
    if (length_of_gap > 0)
      paddings << {:start_timestamp => events[-1][:stop_timestamp] + 1, :stop_timestamp => last_timestamp - 1, :gap => true, :stream => "ds-blank-end.flv"}
    end
        
    paddings
  end  
  
      
  def self.get_video_height(video)
    FFMPEG::Movie.new(video).height
  end
  
  def self.get_video_width(video)
    FFMPEG::Movie.new(video).width
  end
  
  def self.get_video_duration(video)
    FFMPEG::Movie.new(video).duration
  end
  
  def self.get_video_bitrate(video)
    FFMPEG::Movie.new(video).bitrate
  end
  
  def self.get_video_framerate(video)
    FFMPEG::Movie.new(video).frame_rate
  end

  MAX_VID_WIDTH = 640
  MAX_VID_HEIGHT = 480
  
  # Calculate the anamorphic factor for this video.
  #   see http://howto-pages.org/ffmpeg/
  # We need to calculate how much we need to scale
  # the width and height to maintain a 4/3 aspect ratio
  def self.calc_anamorphic_factor(width, height)
    BigBlueButton.logger.info("Task: Calculating anamorphic factor of video")      
    (4.0 * height) / (width * 3.0)
  end
  
  # Is the video orientation in portrait mode?
  def self.portrait?(width, height)
     BigBlueButton.logger.info("Task: Determining if the video orientation in portrait mode")         
     larger_than_max?(width, height) and (width < height)
  end
  
  # Is the video orientation in landscape mode?
  def self.landscape?(width, height)
    BigBlueButton.logger.info("Task: Determining if the video orientation in landscape mode")         
    larger_than_max?(width, height) and (width > height)
  end
  
  # Is the video width and height bigger than 640x480?
  def self.larger_than_max?(width, height)
    BigBlueButton.logger.info("Task: Determining if the video width and height bigger than max values")         
    (width > MAX_VID_WIDTH) and (height > MAX_VID_HEIGHT)
  end
  
  # Calculate the height of the video to maintain 4/3 aspect ratio.
  # We want to fit the video into 640/480 size. If we shrink the width (W)
  # of the video to 640, calculate the height (H) using the formula.
  #  (W/H)*(anamorphic_factor) = (4/3)
  #
  def self.calc_height(anamorphic_factor)
    BigBlueButton.logger.info("Task: Calculating height of video to maintain 4/3 aspect ratio")         
    (3 * MAX_VID_WIDTH * anamorphic_factor) / 4
  end
  
  # Calculate the width of the video to maintain 4/3 aspect ratio.
  # We want to fit the video into 640/480 size. If we shrink the height (H)
  # of the video to 480, calculate the width (W) using the formula.
  #  (W/H)*(anamorphic_factor) = (4/3)
  #
  def self.calc_width(anamorphic_factor)
    BigBlueButton.logger.info("Task: Calculating width of video to maintain 4/3 aspect ratio")         
    (4 * MAX_VID_HEIGHT) / (3 * anamorphic_factor)
  end
  
  # Determine if video is less that 640x480.
  def self.fits_640_by_480?(width, height)
    BigBlueButton.logger.info("Task: Determine if video is less that max width and height")         
    (width < MAX_VID_WIDTH) and (height < MAX_VID_HEIGHT)
  end  
  
  # Determine the width and height of the video that fits
  # within 640x480 while maintaining aspect ratio.
  def self.fit_to_640_by_480(width, height)
    BigBlueButton.logger.info("Fitting the video to the max width and height")
    anamorphic_factor = calc_anamorphic_factor(width, height)
    if (width <= MAX_VID_WIDTH) and (height > MAX_VID_HEIGHT)  
      # Fit the video vertically and adjust the width then pad it to fit into 640x480 video.
      width = calc_width(anamorphic_factor)
      height = MAX_VID_HEIGHT
    elsif (height <= MAX_VID_HEIGHT) and (width > MAX_VID_WIDTH) 
      # Fit the video horizontally and adjust the height then pad the top and bottom to fit the 640x480 video.
      height = calc_height(anamorphic_factor)
      width = MAX_VID_WIDTH
    else
      if (height > width)
        width = calc_width(anamorphic_factor)
        height = MAX_VID_HEIGHT
      elsif (width >= height)
        height = calc_height(anamorphic_factor)
        width = MAX_VID_WIDTH
      end
    end   
    {:width => width.to_i, :height => height.to_i}    
  end
  
  def self.fit_to(width, height, fit_width, fit_height)
    BigBlueButton.logger.info("Fitting the video resolution from #{width}x#{height} to #{fit_width}x#{fit_height}")
    aspect_ratio = width / height.to_f
    if fit_width / fit_height.to_f > aspect_ratio
      height = fit_height
      width = height * aspect_ratio
    else
      width = fit_width
      height = width / aspect_ratio
    end
    BigBlueButton.logger.info("Best fit width #{width.to_i} height #{height.to_i}")
    {:width => width.to_i, :height => height.to_i}    
  end
  
  # Scale the video to 640x480 or smaller
  def self.scale_to_640_x_480(width, height)
    BigBlueButton.logger.info("Scaling the video to the max width and height")
    if not fits_640_by_480?(width, height)
      while (width > MAX_VID_WIDTH or height > MAX_VID_HEIGHT)
        scaled_vid = fit_to_640_by_480(width, height)
        width = scaled_vid[:width]
        height = scaled_vid[:height]
      end   
    end   
    {:width => width, :height => height} 
  end
  
  def self.process_webcam(target_dir, temp_dir, meeting_id) 
    BigBlueButton.logger.info("Processing webcam")
    # Process audio
    BigBlueButton::AudioProcessor.process("#{temp_dir}/#{meeting_id}", "#{target_dir}/audio.ogg")

    # Process video    
    video_dir = "#{temp_dir}/#{meeting_id}/video/#{meeting_id}"
    blank_canvas = "#{temp_dir}/canvas.jpg"
    BigBlueButton.create_blank_canvas(MAX_VID_WIDTH, MAX_VID_HEIGHT, "white", blank_canvas)
            
    events_xml = "#{temp_dir}/#{meeting_id}/events.xml"
    first_timestamp = BigBlueButton::Events.first_event_timestamp(events_xml)
    last_timestamp = BigBlueButton::Events.last_event_timestamp(events_xml)        
    start_evt = BigBlueButton::Events.get_start_video_events(events_xml)
    stop_evt = BigBlueButton::Events.get_stop_video_events(events_xml)               
    matched_evts = BigBlueButton::Events.match_start_and_stop_video_events(start_evt, stop_evt)        
    
    paddings = BigBlueButton.generate_video_paddings(matched_evts, first_timestamp, last_timestamp)
        
    webcams = []
    paddings.concat(matched_evts).sort{|a,b| a[:start_timestamp] <=> b[:start_timestamp]}.each do |comb|
      if (comb[:gap])
      	blank_flv = "#{temp_dir}/#{comb[:stream]}"
        webcams << blank_flv
        BigBlueButton.create_blank_video((comb[:stop_timestamp] - comb[:start_timestamp].to_f)/1000.0, 1000, blank_canvas, blank_flv)
      else
        stripped_webcam = "#{temp_dir}/stripped-wc-#{comb[:stream]}.flv"
        BigBlueButton.strip_audio_from_video("#{video_dir}/#{comb[:stream]}.flv", stripped_webcam)
        scaled_flv = "#{temp_dir}/#{meeting_id}/scaled-wc-#{comb[:stream]}.flv"
        webcams << scaled_flv
        frame_size = BigBlueButton.scale_to_640_x_480(BigBlueButton.get_video_width(stripped_webcam), BigBlueButton.get_video_height(stripped_webcam))
  
        width = frame_size[:width]
        height = frame_size[:height]
        
     		frame_size = "-s #{width}x#{height}"
    		side_padding = ((MAX_VID_WIDTH - width) / 2).to_i
    		top_bottom_padding = ((MAX_VID_HEIGHT - height) / 2).to_i
 
   			# Use for newer version of FFMPEG
    		padding = "-vf pad=#{MAX_VID_WIDTH}:#{MAX_VID_HEIGHT}:#{side_padding}:#{top_bottom_padding}:FFFFFF"       
		    command = "ffmpeg -i #{stripped_webcam} -loglevel fatal -v -10 -aspect 4:3 -r 1000 -vcodec copy #{frame_size} #{padding} #{scaled_flv}" 
		    #BigBlueButton.logger.info(command)
		    #IO.popen(command)
		    #Process.wait                
		    BigBlueButton.execute(command)	
      end
    end
               
    concat_vid = "#{target_dir}/webcam.flv"
    BigBlueButton.concatenate_videos(webcams, concat_vid)        
    BigBlueButton.multiplex_audio_and_video("#{target_dir}/audio.ogg", concat_vid, "#{target_dir}/muxed-audio-webcam.flv")   
  end
  
  def self.process_deskstop_sharing(target_dir, temp_dir, meeting_id) 
    BigBlueButton.logger.info("Processing desktop sharing")               
    blank_canvas = "#{temp_dir}/ds-canvas.jpg"
    BigBlueButton.create_blank_canvas(MAX_VID_WIDTH, MAX_VID_HEIGHT, "white", blank_canvas)
    
    events_xml = "#{temp_dir}/#{meeting_id}/events.xml"
    first_timestamp = BigBlueButton::Events.first_event_timestamp(events_xml)
    last_timestamp = BigBlueButton::Events.last_event_timestamp(events_xml)
        
    start_evts = BigBlueButton::Events.get_start_deskshare_events(events_xml)
    stop_evts = BigBlueButton::Events.get_stop_deskshare_events(events_xml)
        
    matched_evts = BigBlueButton::Events.match_start_and_stop_video_events(start_evts, stop_evts)        
    paddings = BigBlueButton.generate_deskshare_paddings(matched_evts, first_timestamp, last_timestamp)
        
    flvs = []
    paddings.concat(matched_evts).sort{|a,b| a[:start_timestamp] <=> b[:start_timestamp]}.each do |comb|
      if (comb[:gap])
      	blank_flv = "#{temp_dir}/#{comb[:stream]}"
        flvs << blank_flv
        BigBlueButton.create_blank_deskshare_video((comb[:stop_timestamp] - comb[:start_timestamp].to_f)/1000, 1000, blank_canvas, blank_flv)
      else
      	scaled_flv = "#{temp_dir}/#{meeting_id}/deskshare/scaled-#{comb[:stream]}"
        flvs << scaled_flv
        flv_in = "#{temp_dir}/#{meeting_id}/deskshare/#{comb[:stream]}"
        frame_size = BigBlueButton.scale_to_640_x_480(BigBlueButton.get_video_width(flv_in), BigBlueButton.get_video_height(flv_in))

        width = frame_size[:width]
        height = frame_size[:height]
        
     		frame_size = "-s #{width}x#{height}"
    		side_padding = ((MAX_VID_WIDTH - width) / 2).to_i
    		top_bottom_padding = ((MAX_VID_HEIGHT - height) / 2).to_i
 
   			# Use for newer version of FFMPEG
    		padding = "-vf pad=#{MAX_VID_WIDTH}:#{MAX_VID_HEIGHT}:#{side_padding}:#{top_bottom_padding}:FFFFFF"       
		    command = "ffmpeg -i #{flv_in} -loglevel fatal -v -10 -aspect 4:3 -r 1000 #{frame_size} #{padding} -vcodec flashsv #{scaled_flv}" 
		    BigBlueButton.execute(command)
		    #BigBlueButton.logger.info(command)
		    #IO.popen(command)
		    #Process.wait 
      end
    end
               
    BigBlueButton.concatenate_videos(flvs, "#{target_dir}/deskshare.flv")   
  end
  
  # Converts a time in milisseconds to a format that FFmpeg understands
  #   ms - time in milisseconds
  # Example:
  #   ms_to_strtime(1000)
  # Output:
  #   00:00:01.000
  def self.ms_to_strtime(ms)
    t = Time.at(ms / 1000, (ms % 1000) * 1000)
    return t.getutc.strftime("%H:%M:%S.%L")
  end
  
  def BigBlueButton.process_multiple_videos(target_dir, temp_dir, meeting_id, output_width, output_height)
    BigBlueButton.logger.info("Processing webcam videos")

    # Process audio
    BigBlueButton::AudioProcessor.process("#{temp_dir}/#{meeting_id}", "#{target_dir}/audio.ogg")

    # Process video
    blank_color = "000000"
    video_dir = "#{temp_dir}/#{meeting_id}/video/#{meeting_id}"
    blank_canvas = "#{temp_dir}/canvas.jpg"
    BigBlueButton.create_blank_canvas(output_width, output_height, "##{blank_color}", blank_canvas)
            
    events_xml = "#{temp_dir}/#{meeting_id}/events.xml"
    first_timestamp = BigBlueButton::Events.first_event_timestamp(events_xml)
    last_timestamp = BigBlueButton::Events.last_event_timestamp(events_xml)        
    start_evt = BigBlueButton::Events.get_start_video_events(events_xml)
    stop_evt = BigBlueButton::Events.get_stop_video_events(events_xml)               
    matched_evts = BigBlueButton::Events.match_start_and_stop_video_events(start_evt, stop_evt)        
    BigBlueButton.logger.debug("First timestamp: #{first_timestamp}")
    BigBlueButton.logger.debug("Last timestamp: #{last_timestamp}")
    BigBlueButton.logger.debug("Start events:")
    BigBlueButton.logger.debug(start_evt)
    BigBlueButton.logger.debug("Stop events:")
    BigBlueButton.logger.debug(stop_evt)
    BigBlueButton.logger.debug("Matched events:")
    BigBlueButton.logger.debug(matched_evts)
    
    all_events = []
    start_evt.each do |evt|
      event = evt.clone
      event[:type] = "start"
      event[:timestamp] = event[:start_timestamp]
      event.delete(:start_timestamp)
      all_events << event
    end
    stop_evt.each do |evt|
      event = evt.clone
      event[:type] = "stop"
      event[:timestamp] = event[:stop_timestamp]
      event.delete(:stop_timestamp)
      all_events << event
    end
    all_events.sort!{|a,b| a[:timestamp] <=> b[:timestamp]}

    BigBlueButton.logger.debug("All events:")
    BigBlueButton.logger.debug(all_events)
    
    timeline = [ { :timestamp => first_timestamp, :webcams => [] } ]
    all_events.each do |event|
      new_event = { :timestamp => event[:timestamp], :webcams => timeline.last[:webcams].clone }
      if event[:type] == "start"
        new_event[:webcams] << event[:stream]
      elsif event[:type] == "stop"
        new_event[:webcams].delete(event[:stream])
      end
      timeline << new_event
    end
    
    timeline << { :timestamp => last_timestamp, :webcams => [] }
    BigBlueButton.logger.debug("Current timeline:")
    BigBlueButton.logger.debug(timeline)
    
    # removes audio stream
    matched_evts.each do |evt|
      stripped_webcam = "#{temp_dir}/#{meeting_id}/stripped-#{evt[:stream]}.flv"
      BigBlueButton.strip_audio_from_video("#{video_dir}/#{evt[:stream]}.flv", stripped_webcam)
    end
    
    webcams = []
    for i in 1..(timeline.length-1)
      event = timeline[i-1]
      next_event = timeline[i]
      event_duration = next_event[:timestamp] - event[:timestamp]

      BigBlueButton.logger.debug("Processing event:")
      BigBlueButton.logger.debug(event)

      if event_duration == 0 then
        next
      elsif event[:webcams].empty?
        blank_video = "#{temp_dir}/#{meeting_id}/video#{i}.flv"
        webcams << blank_video
        BigBlueButton.create_blank_video_ms(event_duration, 1000, blank_canvas, blank_video)
      else
        # try to find the number of rows and columns to maximize the internal videos
        each_row = 0
        num_rows = 0
        slot_width = 0
        slot_height = 0
        total_area = 0
        num_cams = event[:webcams].length
        for tmp_num_rows in 1..(num_cams)
          tmp_each_row = (num_cams / tmp_num_rows.to_f).ceil
          max_width = (output_width / tmp_each_row).floor
          max_height = (output_height / tmp_num_rows).floor
          if max_width <= 0 or max_height <= 0 then
            next
          end
          
          tmp_total_area = 0
          event[:webcams].each do |stream|
            video_path = "#{temp_dir}/#{meeting_id}/stripped-#{stream}.flv"
            measurements = BigBlueButton.fit_to(BigBlueButton.get_video_width(video_path), BigBlueButton.get_video_height(video_path), max_width, max_height)
            tmp_total_area += measurements[:width] * measurements[:height]
          end
          
          if tmp_total_area > total_area
            slot_width = max_width
            slot_height = max_height
            num_rows = tmp_num_rows
            each_row = tmp_each_row
            total_area = tmp_total_area
          end
        end
                
        BigBlueButton.logger.debug("Using #{num_rows} rows and #{each_row} columns the slot size is #{slot_width}x#{slot_height}")

        # create video canvas
        video_filter = "pad=#{output_width}:#{output_height}:0:0:0x#{blank_color} "
        
        event[:webcams].each_with_index do |stream, index|
          stream_events = matched_evts.select{|s| s[:stream] == stream}[0]
          video_begin = event[:timestamp] - stream_events[:start_timestamp]
          trimmed_video = "#{temp_dir}/#{meeting_id}/video#{i}-#{stream}.flv"
          stripped_video = "#{temp_dir}/#{meeting_id}/stripped-#{stream}.flv"
          BigBlueButton.trim_video(video_begin, event_duration, stripped_video, trimmed_video)

          # sometimes the duration is too small that ffmpeg cannot create a valid video file for it
          # in this cases we will create a blank valid video instead
          # \TODO investigate why it's occurring
          if BigBlueButton.get_video_duration(trimmed_video).nil? || BigBlueButton.get_video_duration(trimmed_video) == 0.0
            BigBlueButton.create_blank_video_ms(event_duration, 1000, blank_canvas, trimmed_video)
          end
          frame_size = BigBlueButton.fit_to(BigBlueButton.get_video_width(trimmed_video), BigBlueButton.get_video_height(trimmed_video), slot_width, slot_height)
          width = frame_size[:width]
          height = frame_size[:height]

          scaled_video = "#{temp_dir}/#{meeting_id}/scaled-video#{i}-#{stream}.flv"
          command = "ffmpeg -i #{trimmed_video} -loglevel fatal -v -10 -aspect 4:3 -r 1000 -vcodec copy -vf scale=#{width}:#{height} #{scaled_video}" 
          BigBlueButton.execute(command)

          slot_x = (index%each_row)       * slot_width  + (output_width  - slot_width  * each_row) / 2
          slot_y = (index/each_row).floor * slot_height + (output_height - slot_height * num_rows) / 2
          x = slot_x + (slot_width  - width)  / 2
          y = slot_y + (slot_height - height) / 2
          
          overlay = " [in#{index}]; movie=#{scaled_video} [mv#{index}]; [in#{index}][mv#{index}] overlay=#{x}:#{y}"
          video_filter << overlay
        end
        BigBlueButton.logger.info("videofilter: #{video_filter}")
        blank_video = "#{temp_dir}/#{meeting_id}/video#{i}-blank.flv"
        BigBlueButton.create_blank_video_ms(event_duration, 1000, blank_canvas, blank_video)
        webcam_video = "#{temp_dir}/#{meeting_id}/video#{i}.flv"
        webcams << webcam_video
        command = "ffmpeg -i #{blank_video} -loglevel fatal -r 1000 -vcodec copy -v -10 -vf \"#{video_filter}\" #{webcam_video}"
        BigBlueButton.execute(command)
      end
    end
    concat_vid = "#{target_dir}/video.flv"
    # if there's no video, it will create a single blank video
    if webcams.empty?
      BigBlueButton.create_blank_video(BigBlueButton.get_video_duration("#{target_dir}/audio.ogg"), 1000, blank_canvas, concat_vid)
    else
      BigBlueButton.concatenate_videos(webcams, concat_vid)
    end

    # create webm video and mux audio
    command = "ffmpeg -i #{target_dir}/audio.ogg -i #{concat_vid} -loglevel fatal -v -10 -vcodec libvpx -b 1000k -threads 0  -map 1:0 -map 0:0 -ar 22050 #{target_dir}/webcams.webm"
    BigBlueButton.execute(command)
  end
  
  # Muxes audio with deskshare video
 # audio_file     : Audio of the recording
 # deskshare_file : Video of shared desktop of the recording

 def self.mux_audio_deskshare(target_dir, audio_file, deskshare_file)
  command = "ffmpeg -i #{audio_file} -i #{deskshare_file} -loglevel fatal -v -10 -vcodec flv -b 1000k -threads 0  -map 1:0 -map 0:0 -ar 22050 #{target_dir}/muxed_audio_deskshare.flv"
  BigBlueButton.execute(command)
  FileUtils.mv("#{target_dir}/muxed_audio_deskshare.flv","#{target_dir}/deskshare.flv")
 end

  
  #########################
  ##  For record button  ##
  #########################
  
  #
  # Process and trims the presenter webcam video according to the events of record button
  #
  
   def self.process_webcam_rb(target_dir, temp_dir, meeting_id) 
	BigBlueButton.logger.info("Processing webcam")
    # Process audio
    BigBlueButton::AudioProcessor.process_rb("#{temp_dir}/#{meeting_id}", "#{target_dir}/audio.ogg")

    # Process video    
    video_dir = "#{temp_dir}/#{meeting_id}/video/#{meeting_id}"
    blank_canvas = "#{temp_dir}/canvas.jpg"
    BigBlueButton.create_blank_canvas(MAX_VID_WIDTH, MAX_VID_HEIGHT, "white", blank_canvas)
            
    events_xml = "#{temp_dir}/#{meeting_id}/events.xml"
    first_timestamp = BigBlueButton::Events.first_event_timestamp(events_xml)
    last_timestamp = BigBlueButton::Events.last_event_timestamp(events_xml)        
    
    start_video_evt = BigBlueButton::Events.get_start_video_events(events_xml)
    stop_video_evt = BigBlueButton::Events.get_stop_video_events(events_xml)               
    matched_video_evts = BigBlueButton::Events.match_start_and_stop_video_events(start_video_evt, stop_video_evt)   

    rec_events = BigBlueButton::Events.get_start_and_stop_rec_events(events_xml)
    matched_rec_evts =  BigBlueButton::Events.match_start_and_stop_rec_events(rec_events)             
	
    piece_events, blank_events = find_recorded_pieces_and_blanks_of_media(matched_video_evts,matched_rec_evts)  
    
    # Remove audio from webcam videos and scale them
    matched_video_evts.each do |evt|
        stripped_webcam = "#{temp_dir}/stripped-wc-#{evt[:stream]}.flv"
        BigBlueButton.strip_audio_from_video("#{video_dir}/#{evt[:stream]}.flv", stripped_webcam)        
        scaled_flv = "#{temp_dir}/#{meeting_id}/scaled-wc-#{evt[:stream]}.flv"
        frame_size = BigBlueButton.scale_to_640_x_480(BigBlueButton.get_video_width(stripped_webcam),
                                                      BigBlueButton.get_video_height(stripped_webcam))       
        width = frame_size[:width]
        height = frame_size[:height]
        frame_size = "-s #{width}x#{height}"
    	  side_padding = ((MAX_VID_WIDTH - width) / 2).to_i
    	  top_bottom_padding = ((MAX_VID_HEIGHT - height) / 2).to_i
        padding = "-vf pad=#{MAX_VID_WIDTH}:#{MAX_VID_HEIGHT}:#{side_padding}:#{top_bottom_padding}:FFFFFF"       
	      command = "ffmpeg -i #{stripped_webcam} -aspect 4:3 -r 1000 -vcodec copy #{frame_size} #{padding} #{scaled_flv}" 
        BigBlueButton.execute(command)
    end     
   
    video_pieces = BigBlueButton.trim_recorded_pieces_of_video(piece_events, "#{temp_dir}/#{meeting_id}",temp_dir, "scaled-wc-")    

    blank_events.each_with_index do |paddings, i|
      paddings.each do |padding|
        duration = BigBlueButton.relative_secs(padding[:start_timestamp], padding[:stop_timestamp])		
        file = "#{video_dir}/#{padding[:stream]}"
        BigBlueButton.create_blank_video(duration, 1000, blank_canvas, file)                    
        padding[:file] = file
      end
    end
          
    blank_events.each do |paddings|
        video_pieces.concat(paddings)    
    end
    webcam_flow = video_pieces.sort{|a,b| a[:start_timestamp] <=> b[:start_timestamp]}
    webcam_flow_files = webcam_flow.map{ |p| p[:file]}
    p webcam_flow_files
    #Concatenate trimmed videos and blanks
    concat_vid = "#{target_dir}/webcam.flv"
    BigBlueButton.concatenate_videos(webcam_flow_files, concat_vid)    
    BigBlueButton.multiplex_audio_and_video("#{target_dir}/audio.ogg", concat_vid, "#{target_dir}/muxed-audio-webcam.flv")   
  end

  #
  # Process and trims the shared desktop video according to the events of record button
  #
  

  def self.process_desktop_sharing_rb(target_dir, temp_dir, meeting_id)                
 
    deskshare_dir = "#{temp_dir}/#{meeting_id}/deskshare" 
    blank_canvas = "#{temp_dir}/ds-canvas.jpg"
    BigBlueButton.create_blank_canvas(MAX_VID_WIDTH, MAX_VID_HEIGHT, "white", blank_canvas)
    
    events_xml = "#{temp_dir}/#{meeting_id}/events.xml"
    first_timestamp = BigBlueButton::Events.first_event_timestamp(events_xml)
    last_timestamp = BigBlueButton::Events.last_event_timestamp(events_xml)
        
    start_evts = BigBlueButton::Events.get_start_deskshare_events(events_xml)
    stop_evts = BigBlueButton::Events.get_stop_deskshare_events(events_xml)
        		
    matched_video_evts = BigBlueButton::Events.match_start_and_stop_video_events(start_evts, stop_evts)        
	
    rec_events = BigBlueButton::Events.get_start_and_stop_rec_events(events_xml)
    matched_rec_evts =  BigBlueButton::Events.match_start_and_stop_rec_events(rec_events)             
	
    piece_events, blank_events = find_recorded_pieces_and_blanks_of_media(matched_video_evts,matched_rec_evts)	
	  piece_events.each do |event|
      event[:stream] = event[:stream].gsub(".flv","")
    end
    
    # Remove audio from webcam videos and scale them
    matched_video_evts.each do |evt|            
	original_deskshare = "#{deskshare_dir}/#{evt[:stream]}"
	scaled_flv = "#{temp_dir}/#{meeting_id}/scaled-ds-#{evt[:stream]}"
        frame_size = BigBlueButton.scale_to_640_x_480(BigBlueButton.get_video_width(original_deskshare),
                                                      BigBlueButton.get_video_height(original_deskshare))
        width = frame_size[:width]
        height = frame_size[:height]
        frame_size = "-s #{width}x#{height}"
    	side_padding = ((MAX_VID_WIDTH - width) / 2).to_i
    	top_bottom_padding = ((MAX_VID_HEIGHT - height) / 2).to_i
        padding = "-vf pad=#{MAX_VID_WIDTH}:#{MAX_VID_HEIGHT}:#{side_padding}:#{top_bottom_padding}:FFFFFF"       
        command = "ffmpeg -i #{original_deskshare} -aspect 4:3 -r 1000  -vcodec flashsv #{frame_size} #{padding} #{scaled_flv}" 
        BigBlueButton.execute(command)       
    end     

    video_pieces = BigBlueButton.trim_recorded_pieces_of_video(piece_events, "#{temp_dir}/#{meeting_id}",temp_dir, "scaled-ds-")    
    blank_events.each_with_index do |paddings, i|
      paddings.each do |padding|
        duration = BigBlueButton.relative_secs(padding[:start_timestamp], padding[:stop_timestamp])		
        file = "#{deskshare_dir}/#{padding[:stream]}"
        BigBlueButton.create_blank_deskshare_video(duration, 1000, blank_canvas, file)                    
        padding[:file] = file
      end
    end
 
    blank_events.each do |paddings|
        video_pieces.concat(paddings)    
    end
    deskshare_flow = video_pieces.sort{|a,b| a[:start_timestamp] <=> b[:start_timestamp]}
    deskshare_flow_files = deskshare_flow.map{ |p| p[:file]}
  
    #Concatenate trimmed videos and blanks
    concat_vid = "#{target_dir}/deskshare.flv"
    BigBlueButton.concatenate_videos(deskshare_flow_files, concat_vid)   
  end
  

  # 
  # Search events of media and blanks that matches periods of record
  # 
  
  def self.find_recorded_pieces_and_blanks_of_media(matched_media_evts,matched_rec_evts)
   pieces_events = []
   blanks_events = []  
      
   #Intersect record's period with media's periods
    matched_media_evts.each do |media_evt|
        media_start = media_evt[:start_timestamp]
        media_stop = media_evt[:stop_timestamp]                

        matched_rec_evts.each do |rec_evt|                            
          rec_start = rec_evt[:start_timestamp]
          rec_stop = rec_evt[:stop_timestamp]                
          #Is this media file or stream in a record period ?
          if media_was_recorded?(media_start, media_stop, rec_start, rec_stop)                            
            #Check init of the record      
            piece_start_ts = rec_start > media_start ? rec_start : media_start
            piece_stop_ts = rec_stop < media_stop ? rec_stop : media_stop                             
            pieces_evt = { :start => relative_secs(media_start, piece_start_ts) ,
                     :stop => relative_secs(media_start, piece_stop_ts),
                     :start_timestamp => piece_start_ts,
                     :stop_timestamp =>  piece_stop_ts,
                     :stream =>  media_evt[:stream]                             
            }           
            pieces_events << pieces_evt                     
            if rec_evt[:media_evts].nil?
              rec_evt[:media_evts] = Array.new
            end                      
            rec_evt[:media_evts] << pieces_evt                  
          end                                     
        end       
     end 
     p matched_rec_evts    
     matched_rec_evts.each_with_index do |rec_evt,i|
       p rec_evt[:media_evts]
       rec_start = rec_evt[:start_timestamp]
       rec_stop = rec_evt[:stop_timestamp]        
       if rec_evt[:media_evts].nil?
        blanks_events << [{ :start_timestamp => rec_start, 
                           :stop_timestamp => rec_stop,
                           :stream => "record_#{i}_blank.flv"}]      
       else               
         paddings = BigBlueButton.generate_deskshare_paddings(rec_evt[:media_evts], rec_start, rec_stop)
         paddings.each { |p| p[:stream] = "record_#{i}_"+p[:stream]}         
         blanks_events << paddings
       end        
     end
     #When media occurs during all record period generate_deskshare_paddings throws empty arrays
     blanks_events.delete_if { |padding| padding.empty? } 
     return pieces_events ,blanks_events
  end




  #
  # Check if the period of existence of the media matches a period of record
  # 
  
  def self.media_was_recorded?(media_start, media_stop, rec_start, rec_stop)
      cond1 = rec_start > media_start && rec_start < media_stop
      cond2 = rec_stop > media_start && rec_stop < media_stop
      cond3 = media_start > rec_start && media_stop < rec_stop
      cond1 || cond2 || cond3
  end      
  
  
  
  # 
  # Generate new video files trimming an original video 
  # 
  
  def self.trim_recorded_pieces_of_video(pieces_events, orig_dir, dest_dir, orig_media_prefix="")
    #Before webcam videos are stripped or scaled before trimmed.
    #orig_media_prefix let you specify the media prefix e.g scaled-wc,stripped-wc,scaled-       
       
    pieces_events.each_with_index do |piece_evt, i|
         original_stream = "#{orig_dir}/#{orig_media_prefix}#{piece_evt[:stream]}.flv"
         trimmed_piece = "#{dest_dir}/piece_#{piece_evt[:stream]}_#{i}.flv"
         start = piece_evt[:start] * 1000
         stop = piece_evt[:stop] * 1000
         #BigBlueButton.trim_video(original_stream, trimmed_piece, start,stop)        
		    BigBlueButton.trim_video(start, stop - start, original_stream, trimmed_piece)
         piece_evt[:file] = trimmed_piece
    end    
  end    
  
  
  # 
  # Trim a video
  # 
  
  #def self.trim_video(input_video, output_video_piece, start,stop) 
  #      duration = stop - start
  #      command = "ffmpeg -i #{input_video} -vcodec copy -acodec copy -ss #{start} -t #{duration}  #{output_video_piece}"
  #      puts "----COMMAND----"
  #     puts "#{command}"
  #     BigBlueButton.execute(command)
  #end
  
  
  #
  # Generate duration from init_time to final_time
  #
  
  def self.relative_secs(init_time, final_time)
       ( (final_time - init_time) / 1000.0 ).round(3)
  end

end

