#!/usr/bin/ruby
require (Dir.getwd)+'/tools/hex_to_bin_converter.rb'
# parse RTP headers
# start with hex, or binary

module RTPTools
  @rtp_string_formats = ["hex","bin"]
  # note
  # h264 is a dynamic payload type
  @payload_types = {"h264"=>123,"h263-1998"=>115,"h263"=>34}
  def RTPTools.parse_rtp_header(rtp_header_string,format="hex")
    rtp_header_string = rtp_header_string.lines.to_a if rtp_header_string.is_a? String

    raise "Error. you need to specify the parsing format. eg. 'hex' or 'bin'" unless @rtp_string_formats.include?(format)
    raise "Error. you need to pass a hex or binary string into the parser parameter 1" unless rtp_header_string.is_a? Array

    # only hex for now, but can use hex_to_bin
    bin_string = NumberFormat.hex_or_bin_conversion(rtp_header_string,"to_bin")
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

    # Timestamp (32 bits)
    # doesn't have to start at 0, in fact it is frowned upon to start at zero, in the case of RTP session hijacking
    rtp_header[:timestamp]                = rtp_header_string[0][6,4] #timestamp 32 bit integer 

    # Synchronization Source (SSRC) identifer
    # this is the unique session identifier for this RTP session
    rtp_header[:ssrc_id]                  = rtp_header_string[0][10,4] # synchronization source (SSRC) identifier


    # find human readable format, so we can see what is going on
    rtp_header_human_readable = RTPTools.parse_rtp_header_containers_to_human_readable_formats(rtp_header)

    #puts "\n"
    rtp_header_human_readable.each {|key,value| puts "#{key} : #{value}\n"}
    #puts "\n"
    
    return rtp_header
  end
  
  # parse the rtp header container values into human readable format
  def RTPTools.parse_rtp_header_containers_to_human_readable_formats(rtp_header_hash)
    raise "Error. You must send over a hash in the parameter" unless rtp_header_hash.is_a? Hash

    begin
      # version: 2 bits (convert to hex)
      rtp_headers_human_readable = {}
      rtp_header_hash[:version].lines.to_a.pack('H*') == "\020" ? rtp_headers_human_readable[:version] = 2 :  rtp_headers_human_readable[:version] = 1
      rtp_header_hash[:padding].lines.to_a.pack('H*') == "\000" ? rtp_headers_human_readable[:padding] = 0 : rtp_headers_human_readable[:padding] = 1
      rtp_header_hash[:extension].lines.to_a.pack('H*') == "\000" ?  rtp_headers_human_readable[:extension] = 0 :  rtp_headers_human_readable[:extension] = 1
      rtp_header_hash[:contributing_sources].lines.to_a.pack('H*') == "\000\000" ? rtp_headers_human_readable[:contributing_sources] = 0 : rtp_headers_human_readable[:contributing_sources] = 1
      rtp_header_hash[:marker].lines.to_a.pack('H*') == "\020" ? rtp_headers_human_readable[:marker] = 1 : rtp_headers_human_readable[:marker] = 0

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
    rescue
      raise "Error. Conversion from Binary to Human Legable Format Failed"
    end
  end

end

# Usage
RTPTools.parse_rtp_header("80731C3B689F91E8443B89B2")