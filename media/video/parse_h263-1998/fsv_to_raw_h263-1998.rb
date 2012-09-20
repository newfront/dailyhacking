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
  
  # iterate through header
  @version =                 (@fsv[0,4]) #version 4 bits
  @codec_name =              @fsv[4,32] #codec name 32 bits
  
  # find codec extension
  @type = VideoFormatTools.get_codec_extension_name(@codec_name)
  
  puts "TYPE: #{@type}\n"
  
  @rtp_fmtp_info =           @fsv[36,128] #fmtp info 128 bits
  @rtp_audio_rate =          (@fsv[164,1]).to_i(16) # audio rate 40 = 64
  @rtp_audio_ptime =         (@fsv[165,1]).to_i(16) #audio payload time
  @rtp_timestamp =           (@fsv[166,1]).to_i(16) #switch_time_t created
  count = 0

  #puts "version: #{@version.to_i(16).to_s}\ncodec_name: #{@codec_name}\nfmtp_info: #{@rtp_fmtp_info}\n"
  
  # works to grab
  # rtp header pattern 80 = version 2, 73 = Marker:0, Payload Type h263-1998, followed by increasing order sequence id 
  for @i in 0..(@hex.size)-1 do
    if @hex[@i,12].join.match(/^80(f|7)3([0123456789ABCDEFabcdef]{20})/i)
      (@rtp_header_locations ||= []) << @i
      count += 1
    end
  end
  #puts "Total Headers Found (HEX METHOD) #{count.to_s}\n\n\n"
  
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
        
        #find_padding = payload_data.index(/40010000/)
        #if find_padding
          #payload_data = payload_data[0,find_padding]
        #end
        
        
        # check the marker bit, if it is one, don't cut of trailing 8 bits
        if rtp_header[:marker].to_i == 1
          #payload_data starts at 28th bit, that gets rid of rtp header and h263-1998 header
          payload_data = "0000"+payload_data[28,payload_data.bytesize-28].to_s
        else
          # start 28 bytes in, end 36 before end of size, 28 + 8 for 8 bytes trailing with P-Frames
          payload_data = "0000"+payload_data[28,payload_data.bytesize-36].to_s
        end
  
        #puts "\n-----------------------------------------------------------\n"
        #puts "Payload Data (type 1):\n#{payload_data}\nBytesize: #{payload_data.bytesize.to_s}"
        #puts "\n-----------------------------------------------------------\n"
      
      else
        payload_data = @hex[current_rtp_header,((@hex.length) - (current_rtp_header))].join
        rtp_header = RTPTools.parse_rtp_header(@hex[current_rtp_header,12].join)
        
        #puts "\n****************************************\n"
        #puts "h263-1998 Payload Header\n"
        #puts payload_data[24,4].to_s
        #puts "\n****************************************\n"
        
        if rtp_header[:marker].to_i == 1
          # start 28 bytes in
          payload_data = "0000"+payload_data[28,payload_data.bytesize-28].to_s
        else
          # start 28 bytes in, end 36 before end of size, 28 + 8 for 8 bytes trailing with P-Frames
          payload_data = "0000"+payload_data[28,payload_data.bytesize-36].to_s
        end
        
        #puts "\n-----------------------------------------------------------\n"
        #puts "Payload Data (type 2):\n#{payload_data}\n"
        #puts "\n-----------------------------------------------------------\n"
      end
      
      unless payload_data.nil?
        (@raw_h263_hex_string ||= "") << payload_data unless !@sequence_order_correct
      end
    rescue
      raise "Failed to read h263-1998 format."
    end
  end
  
  # if we are here, then we have our hex only data
  # show our collected h263-1998 data
  #puts "\nHEX STRING FROM h263-1998 collection algorithm:\n #{@raw_h263_hex_string}\n"
  
  # convert hex_string back to bin_string
  #puts "saving binary string from hex string"
  bin_video_data = VideoHelper.write_binary_from_hex_string(@raw_h263_hex_string)
  
  #STDOUT.write(bin_video_data) #looks good
  
  # save bin_string to file
  VideoHelper.save_raw_h26x($argv[0],bin_video_data,@type)
end


raise "you need to specify an FSV file in ARGV[0]. (ex) ruby fsv_to_raw_h263-1998.rb /path/to/your/file.fsv" unless !$argv[0].nil?
read_file_to_binary