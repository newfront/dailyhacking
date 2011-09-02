#!/usr/bin/ruby

# parse RTP headers
# start with hex, or binary

@rtp_string_formats = ["hex","bin"]
# note
# h264 is a dynamic payload type
@payload_types = {"h264"=>123,"h263-1998"=>115,"h263"=>34}

def parse_rtp_header(rtp_header_string,format="hex")
  
  rtp_header_string = rtp_header_string.lines.to_a if rtp_header_string.is_a? String
  
  raise "Error. you need to specify the parsing format. eg. 'hex' or 'bin'" unless @rtp_string_formats.include?(format)
  raise "Error. you need to pass a hex or binary string into the parser parameter 1" unless rtp_header_string.is_a? Array
  
  # only hex for now, but can use hex_to_bin
  bin_string = hex_or_bin_conversion(rtp_header_string,"to_bin")
  
  # now that we have bin_string back, we can iterate through it to read off the header
  
  # read string format into hash
  rtp_header = {}
  # Version, Padding, Extension, Contributing Sources (8 bits)
  rtp_header[:version]                  = bin_string[0,2]           # 2 bit version
  rtp_header[:padding]                  = bin_string[2,1]                # 1 bit padding
  rtp_header[:extension]                = bin_string[3,1]              # 1 bit eXtension
  rtp_header[:contributing_sources]     = bin_string[4,4]   # 4 bits Contributing Sources

  # Marker, and Payload Type (8 bits)
  rtp_header[:marker]                   = bin_string[8,1] # 1 bit marker bit
  rtp_header[:payload_type]             = rtp_header_string[0][2,2]
  # Sequence Number (16 bits)
  # doesn't have to start at 0, in fact it is frowned upon to start at zero, in the case of RTP session hijacking
  rtp_header[:sequence_number]          = rtp_header_string[0][4,4]
  
  puts "sequence: #{rtp_header[:sequence_number]}"

  # Timestamp (32 bits)
  # doesn't have to start at 0, in fact it is frowned upon to start at zero, in the case of RTP session hijacking
  rtp_header[:timestamp]                = rtp_header_string[0][6,4] #timestamp 32 bit integer 

  # Synchronization Source (SSRC) identifer
  # this is the unique session identifier for this RTP session
  rtp_header[:ssrc_id]                  = rtp_header_string[0][10,4] # synchronization source (SSRC) identifier

  
  # find human readable format, so we can see what is going on
  rtp_header_human_readable = parse_rtp_header_containers_to_human_readable_formats(rtp_header)
  
  puts "\n"
  rtp_header_human_readable.each {|key,value| puts "#{key} : #{value}\n"}
  puts "\n"
  
end

# parse the rtp header container values into human readable format
def parse_rtp_header_containers_to_human_readable_formats(rtp_header_hash)
  raise "Error. You must send over a hash in the parameter" unless rtp_header_hash.is_a? Hash
  
  #begin
    # version: 2 bits (convert to hex)
    rtp_headers_human_readable = {}

    rtp_header_hash[:version].lines.to_a.pack('H*') == "\020" ? rtp_headers_human_readable[:version] = 2 : rtp_headers_human_readable[:version] = 1
    
    rtp_header_hash[:padding].lines.to_a.pack('H*') == "\000" ? rtp_headers_human_readable[:padding] = 0 : rtp_headers_human_readable[:padding] = 1
    
    rtp_header_hash[:extension].lines.to_a.pack('H*') == "\000" ?  rtp_headers_human_readable[:extension] = 0 :  rtp_headers_human_readable[:extension] = 1
    
    rtp_header_hash[:contributing_sources].lines.to_a.pack('H*') == "\000\000" ? rtp_headers_human_readable[:contributing_sources] = 0 : rtp_headers_human_readable[:contributing_sources] = 1
    
    rtp_header_hash[:marker].lines.to_a.pack('H*') == "\020" ? rtp_headers_human_readable[:marker] = 1 : rtp_headers_human_readable[:marker] = 0
    
    #@payload_types
    
    @payload_types.each do |key,value| 
      if value == rtp_header_hash[:payload_type].to_s.to_i(16)
        rtp_headers_human_readable[:payload_type] = key
        break
      end
    end
    
    rtp_headers_human_readable[:sequence_number] = rtp_header_hash[:sequence_number].to_s.to_i(16)
    
    rtp_headers_human_readable[:timestamp] = rtp_header_hash[:timestamp].to_i(16)
    
    rtp_headers_human_readable[:ssrc_id] = rtp_header_hash[:ssrc_id].to_i(16)

    return rtp_headers_human_readable
#rescue
  #raise "Error. Conversion from Binary to Human Legable Format Failed"
#end
  
end

# hex table
@hex_table = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]
@bin_table = ["0000","0001","0010","0100","0101","0110","0111","1000","1001","1010","1011","1100","1101","1111"]
def hex_or_bin_conversion(hex_array, direction="to_bin")
  raise "hex_array needs to be an ARRAY" unless hex_array.is_a? Array
  tmp = ''
  
  # if the hex array is flattened, unflatten as hex pairs
  if hex_array.length == 1
    bin = []
    hex_array.to_s.scan(/../).map do |match| 
      bin << match
    end
    hex_array = bin
  end
  
  begin
    hex_array.each do |hex|
      begin
        for @i in 0..(@hex_table.size-1) do
          if hex[0,1] == @hex_table[@i]
            tmp << @bin_table[@i]
            break
          end
        end
      rescue
        puts"first hex to bin chunk conversion failed"
      end

      begin
        for @k in 0..(@hex_table.size-1) do
          if hex[1,1] == @hex_table[@k]
            tmp << @bin_table[@k]
            break
          end
        end
      rescue
        puts"second hex to bin chunk conversion failed"
      end
    end
    return tmp
  rescue
    puts "failed to convert hex to binary"
  end
end

# main loop
parse_rtp_header("80731d5356954b784e491365") #1 [53]
#parse_rtp_header("80731d5456954b784e491365") #2 [54]
#parse_rtp_header("80731d5556954b784e491365") #3 [55]
#parse_rtp_header("80731d5656954b784e491365") #4 [56]
#parse_rtp_header("80731d5756954b784e491365") #5 [57]
#parse_rtp_header("80731d5856954b784e491365") #6 [58]
#parse_rtp_header("80731d5956954b784e491365") #7 [59]
# last frame
#parse_rtp_header("80731eb956a802364e491365") #n

# rtp header with h263 payload type
#parse_rtp_header("8022198e7f240757ccdd137e")

# rtp header with h264 payload type
#parse_rtp_header("807b089a594f7d114f1f3823")

#parse_rtp_header("80731802686a9b8c443b89b2")
#parse_rtp_header("80731803686a9b8c443b89b2")
#parse_rtp_header("80731804686a9b8c443b89b2")
#parse_rtp_header("80731805686a9b8c443b89b2")
#parse_rtp_header("80731806686a9b8c443b89b2")