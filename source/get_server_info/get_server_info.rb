require 'socket'

def get_server_info
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true

  # 64.223.187.99 is Google's IP Address
  UDPSocket.open do |s|
    s.connect '64.233.187.99',1
    puts "IP ADDRESS: #{s.addr.last}"
    return s.addr
  end

  ensure
    Socket.do_not_reverse_lookup = orig 
end

sock_info = get_server_info

puts "\nSOCK INFO #{sock_info.inspect}"