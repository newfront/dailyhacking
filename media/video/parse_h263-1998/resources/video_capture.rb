require 'rubygems'
require 'eventmachine'
require 'socket'

$argv = ARGV

puts "ARGS #{$args.inspect}"

class VideoPacketSniffer < EventMachine::Connection
  
  def initalize(*args)
    super
    @listening_on_port = args[0]
  end
  
  def post_init
    puts "ready to listen on socket for incoming data... #{@listening_on_port}\n"
  end
  
  def receive_data(data)
    puts "data: #{data}\n"
  end
  
  def unbind
    puts "client no longer listening..."
  end
  
end

EventMachine::run do
  EventMachine::open_datagram_socket('0.0.0.0',$argv[0], VideoPacketSniffer, $argv[0])
  EM.next_tick {
    puts "waiting..."
  }
end

# Each User Session from CAW / [n] Site will have a hook into sip_gw_server on port 7779 (TCP)
# Each User will auto-register on SIPGW, which will in turn REGISTER them with the CONVO SIP SERVER (FreeSwitch)