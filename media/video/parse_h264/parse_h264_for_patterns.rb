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
  
  count = 0

  pattern = /^00008([a-f0-9])/i
  
  for @i in 0..(@hex.size)-1 do
    if @hex[@i,3].join.match(pattern)
      (@rtp_header_locations ||= []) << @i
      puts "FOUND Sequence #{@hex[@i,4].join}"
      count += 1
    end
  end
  
  return
  
end

raise "you need to specify an recorded stream file (pcap, stream file) in ARGV[0]. (ex) ruby fsv_to_raw_h264.rb /path/to/your/file.fsv" unless !$argv[0].nil?
read_file_to_binary 

