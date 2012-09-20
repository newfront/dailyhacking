#!/usr/bin/ruby
require (Dir.getwd)+"/tools/hex_to_bin_converter.rb"

module VideoHelper
  
  def VideoHelper.write_binary_from_hex_string(hex_string)
    raise "Error. Missing hex_string in parameter one. " unless !hex_string.nil?
    return hex_string.lines.to_a.pack('H*')
  end
  
  
  # opens up a file, and reads binary
  # saves binary string to variable fsv
  # returns fsv
  def VideoHelper.open_up_file_parse_bin_to_hex(file,read_type)
    # open up fsv file
    fsv = ''
    tmp = ''
    File.open(file,read_type) do |f|
      # grab each bit and push into array
      while !f.eof?
        # read in larger chunks, fairly fast
        fsv << f.read(1024)
      end
    end
    puts "FILE SIZE: #{(fsv.length)/1024} kb"
    return fsv
  end
  
  # Opens up a File, writes bin data and closes file
  # input_name = "test_movie.fsv"
  # binary_data = binary_data_string (use VideoHelper.write_binary_from_hex_string to get binary string)
  # type = h263,h263p,h264
  
  def VideoHelper.save_raw_h26x(input_name,binary_data,type)
    begin
      save_file_name = input_name.to_s.gsub(".fsv","."+type)

      puts "save to #{save_file_name}\n"
      File.open(save_file_name,"wb") do |f|
        f.write(binary_data)
      end
      return true
    rescue
      raise "Error saving raw h26x video data."
    end
  end
  
  # used to find similarity between strings
  def VideoHelper.compute_sum_of_squares(value1,value2)
    sum = (value2 - value1)**2
    return 1/(1+Math.sqrt(sum))
  end
  
  # expects payload header as hex
  # ex. "0400"
  def VideoHelper.parseh263_1998_payload_header(payload_header)
    # hex to true bin
    raise "Error. payload header must be hex String" unless payload_header.is_a? String
    hex_as_bin = NumberFormat.hex_or_bin_conversion(payload_header,"to_bin")
    puts "hex_as_bin #{hex_as_bin}"
  end
  
end



module VideoFormatTools
  
  # FSV FILE HEADER PARSER
  # usage, submit first 165 bytes of FSV file, return hash of header values
  def VideoFormatTools.parse_fsv_header(header)
    raise "Error. You need to pass a 167 byte string as the only parameter." unless header.bytesize == 167
    raise "Error. You need to pass a String as the header parameter." unless header.is_a? String
    
    begin
      # iterate through header
      fsv_header = {}
      fsv_header[:version]          =  header[0,4]              # version 4 bits
      fsv_header[:codec_name]       =  header[4,32]             # codec name 32 bits
      fsv_header[:rtp_fmtp_info]    =  header[36,128]           # fmtp info 128 bits
      fsv_header[:rtp_audio_rate]   =  header[164,1].to_i(16)   # audio rate 40 = 64
      fsv_header[:rtp_audio_ptime]  =  header[165,1].to_i(16)   # audio payload time
      fsv_header[:rtp_timestamp]    =  header[166,1].to_i(16)   # switch_time_t created
      return fsv_header
    rescue
      raise "Error. Failed to parse FSV header."
    end
  end
  
  # grab the real codec extension name
  def VideoFormatTools.get_codec_extension_name(codec_code)
  
    if codec_code.match(/h263-(1998|2000)/i)
      return "h263p"
    elsif codec_code.match(/h263/i)
      return "h263"
    elsif codec_code.match(/h264/i)
      return "h264"
    end
  end
  
end