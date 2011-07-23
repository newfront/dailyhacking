######################################
# Requires ngrep and root priviledges
######################################
require 'eventmachine'
require 'json'
require 'pp'


def format_command
  @cmd = "ngrep "
  @cmd << "-d #{@options['device']}" unless !@options.has_key?("device")
  @cmd << " port #{@options['port']}" unless !@options.has_key?("port")
  @cmd << " #{@options['filter']}" unless !@options.has_key?("filter")
  return @cmd.to_s
end

# em-ngrep.rb {"device":"en0","port":80,"filter":"SIP/2.0"}
# em-ngrep.rb device:en0 port:80 filter:SIP/2.0
unless ARGV.nil?
  @args = ARGV
  # ngrep -d en0 SIP/2.0
  # ["device:en0", "port:80", "filter:SIP/2.0"]
  @options = Hash.new 
  @args.each {|option|
    k,v = option.split(/:/)
    @options.store(k,v)
  }
  pp @options
else
  raise "Please include "
end

module SipHandler
  
  def post_init
    puts "connected to interface"
  end
  
  # any data matched by ngrep
  def receive_data data
    parse_data data
  end
  
  def benchmark &block
    start_time = Time.now
    block.call
    end_time = Time.now
    puts "Time: #{(end_time.to_f - start_time.to_f).to_s} seconds offset"
    puts "TS: #{end_time.to_s}"
  
  end
  
  # parse message chunks
  def parse_data data
    
    tmp = data
    bytes = tmp.bytesize
    puts bytes.to_s
    if bytes.to_i > 200
      pp tmp
      # parse header
      packet_pattern = /([U|T])([ 0-9.]*)(:)(\d*)(\W->\W)([ 0-9.]*)(:)(\d*)/i
      infos = tmp.match(packet_pattern).to_a
      
      #return nil unless !infos.is_a? Array
      message = "\nPacket\n"
      infos[1] == "U" ? message << "From:" : message << "To:"
      message << "#{infos[2].to_s.strip}:#{infos[4].to_s.strip}\n"
      infos[1] == "U" ? message << "To:" : message << "From:"
      message << "#{infos[6].to_s.strip}:#{infos[8].to_s.strip}\n\n"
      puts message
      
      # parse out message body
      body = tmp.match(/\\n/).to_a
      pp body
      
      # Can stop event loop if conditions are met
      #EventMachine::stop_event_loop
      
    else
      return
    end
    
  end

  def unbind
    puts "ruby closed with exit status: #{get_status.exitstatus}"
  end
end

EventMachine.run{
  #cb = EventMachine.callback
  EventMachine.popen(format_command, SipHandler)
}