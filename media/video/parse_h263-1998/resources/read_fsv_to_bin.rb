#!/usr/bin/ruby
$argv = ARGV unless ARGV.nil?
@fsv = ''
@hex = []

def read_file_to_binary(file=nil)
  
  file = $argv[0] unless $argv.nil?
  raise "you need to specify an FSV file." unless !file.nil?
  
  # open up fsv file
  File.open(file,"rb") do |f|
    # grab each bit and push into array
    while !f.eof?
      @fsv << f.read(1)
    end
    # check for h263/h264 payload formats
  end
  
  # byte to hex
  @fsv.each_byte {|byte| @hex << "%02X" % byte}
  # iterate through header
  
  version =                 (@fsv[0,4]).to_i(16) #version 4 bits
  codec_name =              @fsv[4,32] #codec name 32 bits
  rtp_fmtp_info =           @fsv[36,128] #fmtp info 128 bits
  rtp_audio_rate =          (@fsv[164,1]).to_i(16) # audio rate 40 = 64
  rtp_audio_ptime =         (@fsv[165,1]).to_i(16) #audio payload time
  rtp_timestamp =           (@fsv[166,1]).to_i(16) #switch_time_t created
  count = 0
  
  for @i in 0..(@hex.size)-1 do
    # rtp h263 header
    if @hex[@i,4].join.match(/00(60|70)0000/i)
      (@rtp_header_locations ||=[]) << @i
    end
    count += 1
  end
  
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
        payload_data = @hex[current_rtp_header+4,((next_rtp_header -12) - (current_rtp_header-12) - 12 - 8)].join
        # if there is extra padding, kill it
        # /40010000(0|8|F)*/i
        find_padding = payload_data.index(/40010000/)
        payload_data = payload_data[0,find_padding] if find_padding
      else
        payload_data = @hex[current_rtp_header+4,((@hex.length) - (current_rtp_header+4))].join
      end
      (@raw_h263_hex_string ||= "") << payload_data
    rescue
      #puts"there is not a next RTP header location to locate\n"
    end
  end
 
  if save_raw_h263(write_binary_from_hex_string(@raw_h263_hex_string))
    puts "save complete"
  else
    puts "save failed"
  end
end

def write_binary_from_hex_string(hex_string)
  return hex_string.to_a.pack('H*')
end

def save_raw_h263(binary_data)
  begin
    save_file_name = $argv[0].to_s.gsub(".fsv",".h263")
    
    puts "save to #{save_file_name}\n"
    File.open(save_file_name,"wb") do |f|
      f.write(binary_data)
    end
    return true
  rescue
    raise "Error saving raw h263 video data." 
  end
end

read_file_to_binary