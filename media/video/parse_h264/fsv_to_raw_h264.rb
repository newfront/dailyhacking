#!/usr/bin/ruby
require Dir.getwd+'/tools/rtp_header_parser.rb'
require Dir.getwd+'/tools/video_helpers.rb'

$argv = ARGV unless ARGV.nil?
@fsv = ''
@hex = []

def read_file_to_binary(file=nil)
  
  if file.nil?
    file = $argv[0]
  end
  
  # open file in read,binary mode, parse each byte to variable
  @fsv = VideoHelper.open_up_file_parse_bin_to_hex(file,"rb")
  
  # byte to hex
  @fsv.each_byte do |byte|
    @hex << "%02X" % byte
  end
  
  @fsv_header = VideoFormatTools.parse_fsv_header(@fsv[0,167])
  
  puts "\nFSV FILE TYPE\nVersion: #{@fsv_header[:version]}\nCodec Name: #{@fsv_header[:codec_name]}\nFMTP INTO: #{@fsv_header[:rtp_fmtp_info]}\n"
  
  # profile-level-id=42801f 
  # Packetization Mode = 0 | Single NAL Unit Mode (only Single NAL unit Frames, no STAP-As, or FU-As)
  # level-asymmetry-allowed=1 | 
  # max-mbps=108000 | Max Macroblocks per second = 108,000
  
  # find codec extension
  @type = VideoFormatTools.get_codec_extension_name(@fsv_header[:codec_name])
  puts "TYPE: #{@type}\n"
  
  count = 0

  #puts "version: #{@version.to_i(16).to_s}\ncodec_name: #{@codec_name}\nfmtp_info: #{@rtp_fmtp_info}\n"
  
  # sync_source_id usage. 
  # {"sync_id":count}
  # ex: {"cb7d8a90"=>32, "ffffffff"=>3}, we know that cb7d8a90 is the pattern that must be in each true rtp header since its value is higher
  
  @sync_source_id = {}
  
  # loop through headers, grab everything that matches criteria
  # (there will be some misc noise in most files that sneaks in... use @sync_source_id intervals to check for the correct sync_source_id in the set)
  for @i in 0..(@hex.size)-1 do
    #puts "HEX PATTERN #{@hex[@i,12].join}" if (@hex[@i,12].join).match(/^80(f|7)b([0-9a-f]*)/i)
    if @hex[@i,12].join.match(/^80(f|7)b([0-9a-f]*)/i)
      (@rtp_header_locations ||= []) << @i
      tmp = @hex[@i,12].join[(@hex[@i,12].join).size-8,(@hex[@i,12].join).size]
      if @sync_source_id.has_key? tmp
        tmp_count = @sync_source_id.fetch(tmp)+1
        @sync_source_id.store(tmp,tmp_count)
      else
        @sync_source_id.store(tmp,1)
      end
      count += 1
    end
  end
  
  # loop through headers, grab rtp headers and stuff into @rtp_headers Array, also grab last 4 bytes, and push into @sync_source_id Hash
  #for @j in 0..(headers.size-1) do
    #(@rtp_headers ||= []) << headers[@j] if headers[@j].match(pattern)
    # now check the last 5 values match, and add to array
    #tmp = headers[@j][headers[@j].size-8,headers[@j].size]
    #if @sync_source_id.has_key? tmp
      #tmp_count = @sync_source_id.fetch(tmp)+1
      #@sync_source_id.store(tmp,tmp_count)
    #else
      #@sync_source_id.store(tmp,1)
    #end
  #end

  puts @sync_source_id.inspect

  # spit out @sync_source_id.values into @main_sync_source
  # sort array desc order
  
  #puts "sort by desc order, rtp header sync source id"
  #@main_sync_source = @sync_source_id.values.sort {|x,y| y <=> x }

  # find key for value in original @sync_source_id hash
  #@sync_source_id.each {|key,value| 
    #if value == @main_sync_source[0]
      #@real_sync_source_id = key
      #break
    #end
  #}
  #puts "TRUE SYNC SOURCE ID: #{@real_sync_source_id.to_s}"

  # delete from headers array where last 4 bytes are not equal to the @real_sync_source_id
  #for @i in 0..(headers.size-1) do
    #(@real_rtp_headers ||= []) << headers[@i] unless headers[@i][headers[@i].size-8,headers[@i].size] != @real_sync_source_id
  #end
  
  # read hex, find rtp header patterns, grab H.263 RFC4629 payload
  
  @last_rtp_header_sequence_number = 0
  @current_rtp_header_sequence_number = 0
  @sequence_order_correct = false
  
  for @k in 0..(@rtp_header_locations.size-1) do 
    # show the full capture in hex from the rtp header to the position of the next rtp header
    begin
      previous_rtp_header = 0
      current_rtp_header= 0
      next_rtp_header = 0
      
      previous_rtp_header = @rtp_header_locations[(@k-1)] if @k >= 1
      current_rtp_header = @rtp_header_locations[@k]
      next_rtp_header = @rtp_header_locations[(@k+1)] if @k < (@rtp_header_locations.size-1)
      # why current_rtp_header +4, the h263 payload header has a 4 byte header length
      if @k < (@rtp_header_locations.size-1)
        # grab the RTP header and parse format for usable values
        rtp_header = RTPTools.parse_rtp_header(@hex[current_rtp_header,12].join)
        
        # grab sequence number from hex to decimal
        @current_rtp_header_sequence_number = rtp_header[:sequence_number].to_i(16)
        
        # Check that packets are not out of order
        # also helps us check errors in rtp header search regexp
        if @current_rtp_header_sequence_number > @last_rtp_header_sequence_number
          if (@current_rtp_header_sequence_number == @last_rtp_header_sequence_number+1 ) || @last_rtp_header_sequence_number == 0
            #puts "sequence is incrementing : #{@current_rtp_header_sequence_number.to_s} > #{@last_rtp_header_sequence_number.to_s}" 
            #puts "#{@hex[current_rtp_header,12].join}"
            @sequence_order_correct = true
            @last_rtp_header_sequence_number = @current_rtp_header_sequence_number
          else
            #puts "(BAD) #{@hex[current_rtp_header,12].join}"
            #puts rtp_header.inspect
            puts "sequence is out of order : #{@current_rtp_header_sequence_number.to_s} > #{@last_rtp_header_sequence_number.to_s}"
            @sequence_order_correct = false
          end
        else
          #puts "RTP HEADER\n#{@hex[current_rtp_header,12].join}"
          #puts rtp_header.inspect
          puts "sequence is out of order : #{@current_rtp_header_sequence_number.to_s} > #{@last_rtp_header_sequence_number.to_s}"
          @sequence_order_correct = false
        end
        
        payload_data = @hex[current_rtp_header,((next_rtp_header) - (current_rtp_header))].join
        
        # if there is extra padding, kill it
        # /40010000(0|8|F)*/i
        
        find_padding = payload_data.index(/40010000/)
        if find_padding
          payload_data = payload_data[0,find_padding]
        end
        
        puts "\n****************************************\n"
        puts "h264 Payload NAL unit header\n"
        puts payload_data[24,2].to_s
        puts "\n****************************************\n"
        
        
        # check the marker bit, if it is one, don't cut of trailing 8 bits
        if rtp_header[:marker].to_i == 1
          #payload_data starts at 26th bit, that gets rid of rtp header and h264 NAL Unit
          # not sure if nal unit needs to go yet
          # not sure if it is expecting added 2 zero byte bytes
          payload_data = "000001"+payload_data[24,payload_data.bytesize-24].to_s
        else
          # start 26 bytes in, end 34 before end of size, 26 + 8 for 8 bytes trailing with P-Frames
          payload_data = "000001"+payload_data[24,payload_data.bytesize-32].to_s
        end
  
        puts "\n-----------------------------------------------------------\n"
        puts "Payload Data (type 1):\n#{payload_data}\nBytesize: #{payload_data.bytesize.to_s}"
        puts "\n-----------------------------------------------------------\n"
      
      else
        payload_data = @hex[current_rtp_header,((@hex.length) - (current_rtp_header))].join
        rtp_header = RTPTools.parse_rtp_header(@hex[current_rtp_header,12].join)
        
        find_padding = payload_data.index(/40010000/)
        if find_padding
          payload_data = payload_data[0,find_padding]
        end
        
        puts "\n****************************************\n"
        puts "h264 Payload NAL unit header\n"
        puts payload_data[24,2].to_s
        puts "\n****************************************\n"
        
        if rtp_header[:marker].to_i == 1
          #payload_data starts at 26th bit, that gets rid of rtp header and h264 NAL Unit
          # not sure if nal unit needs to go yet
          # not sure if it is expecting added 2 zero byte bytes
          payload_data = "000001"+payload_data[24,payload_data.bytesize-24].to_s
        else
          # start 26 bytes in, end 34 before end of size, 26 + 8 for 8 bytes trailing with P-Frames
          payload_data = "000001"+payload_data[24,payload_data.bytesize-32].to_s
        end
        
        puts "\n-----------------------------------------------------------\n"
        puts "Payload Data (type 2):\n#{payload_data}\n"
        puts "\n-----------------------------------------------------------\n"
      end
      
      unless payload_data.nil?
        (@raw_h26x_hex_string ||= "") << payload_data unless !@sequence_order_correct
      end
    rescue
      raise "Failed to read h263-1998 format."
    end
  end
  
  # if we are here, then we have our hex only data
  # show our collected h263-1998 data
  #puts "\nHEX STRING FROM h263-1998 collection algorithm:\n #{@raw_h26x_hex_string}\n"
  
  # convert hex_string back to bin_string
  puts "saving binary string from hex string"
  bin_video_data = VideoHelper.write_binary_from_hex_string(@raw_h26x_hex_string)
  
  #STDOUT.write(bin_video_data) #looks good
  
  # save bin_string to file
  VideoHelper.save_raw_h26x($argv[0],bin_video_data,@type)
end

raise "you need to specify an FSV file in ARGV[0]. (ex) ruby fsv_to_raw_h264.rb /path/to/your/file.fsv" unless !$argv[0].nil?
read_file_to_binary 

