#!/usr/bin/ruby

# open up fsv file (read, binary)
# parse binary bits into string
# read fsv 

$argv = ARGV unless ARGV.nil?

# hex table
@hex_table = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
@bin_table = ["0000","0001","0010","0100","0101","0110","0111","1000","1001","1010","1011","1100","1101","1111"]

def read_file_to_binary(file=nil)
  file = $argv[0] unless $argv.nil?
  raise "you need to specify an FSV file." unless !file.nil?
  
  @fsv = ''
  @hex = []
  
  File.open(file,"rb") do |f|
    
    # grab each bit and push into array
    while !f.eof?
      @fsv << f.read(1)
    end
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
  
  for @i in 0..(@hex.size-1) do
    
    if @hex[@i,3].join.match(/004000/i)
      (@rtp_header_locations ||=[]) << @i
    end
    
    #print @hex[@i] if @i > 167
    count += 1
  end
  
  # makes sense, last frame is actually the first packet captured, it plays in reverse captured format
  #for @k in 0..(@hex.size-1) do
    #996cd796d7971e9ee6aea4b0a2f8f754 matches (first frame)
    # 0000996cd796d7971e9ee6aea4b0a2f8 matched (first frame)
    #if @hex[@k,8].join.match(/000080060c0d26b8/i)
      #puts"got first h263 payload header at #{@k}" #528
      #puts"got ITU-T Recommendation H263 "
      #break
    #end
  #end
  
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
        payload_data = "0000"+@hex[current_rtp_header+4,((next_rtp_header -12) - (current_rtp_header-12) - 12 - 8)].join
        # if there is extra padding, kill it
        # /40010000(0|8|F)*/i
        find_padding = payload_data.index(/40010000/)
        if find_padding
          #puts"This h263 video chunk has been padded. \n"
          payload_data = payload_data[0,find_padding]
        end
      else
        payload_data = "0000"+@hex[current_rtp_header+4,((@hex.length) - (current_rtp_header+4))].join
        find_padding = payload_data.index(/40010000/)
        if find_padding
          #puts"This h263 video chunk has been padded. \n"
          payload_data = payload_data[0,find_padding]
        end
      end
      (@raw_h263_hex_string ||= "") << payload_data
    rescue
      #puts"there is not a next RTP header location to locate\n"
    end
    #puts"\n-------------------------------------------\n\n"
  end
  
  puts "\n--------------------------\n"
  puts "\n\n RAW H263 HEX STRING \n\n"
  puts @raw_h263_hex_string
  puts "\n--------------------------\n"
  
  puts "\n\nTotal h263 headers captured and parsed: #{@rtp_header_locations.size.to_s}\n"
  
  if save_raw_h263(write_binary_from_hex_string(@raw_h263_hex_string))
    puts "save complete"
  else
    puts "save failed"
  end
  
end

def write_binary_from_hex_string(hex_string)
  
  return hex_string.lines.to_a.pack('H*')
  
end

def save_raw_h263(binary_data)
  
  # $argv[1] == save_file_name
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


def hex_to_bin(hex_array)
  raise "hex_array needs to be an ARRAY" unless hex_array.is_a? Array
  tmp = ''
  hex_array.each do |hex|
    
    begin
    for @i in 0..(@hex_table.size-1) do
      if hex[0,1] == @hex_table[@i]
        tmp << @bin_table[@i]
        break
      end
    end
    rescue
      #puts"first hex lookup failed"
    end
    
    begin
    for @k in 0..(@hex_table.size-1) do
      if hex[1,1] == @hex_table[@k]
        tmp << @bin_table[@k]
        break
      end
    end
    rescue
      #puts"second bin lookup failed"
    end
  end
  return tmp
end

# test hex to binary conversion
#puts"hex_to_bin #{hex_to_bin(["00","60","00","00"])}"

read_file_to_binary