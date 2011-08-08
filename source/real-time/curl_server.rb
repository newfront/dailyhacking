######################################
# Requires ngrep and root priviledges
######################################
require 'eventmachine'
require 'json'
require 'pp'

module TweetHandler
  
  def post_init
    puts "connected to interface"
  end
  
  # any data matched by ngrep
  def receive_data data
    puts "DATA: #{data.inspect}"
    #parse_data data
  end
  
  def parse_data data
    
    begin
      data = JSON.parse(data)
      pp data
    rescue
      puts "Broke...."
    end
    
  end
  
  def benchmark &block
    start_time = Time.now
    block.call
    end_time = Time.now
    puts "Time: #{(end_time.to_f - start_time.to_f).to_s} seconds offset"
    puts "TS: #{end_time.to_s}"
  end

  def unbind
    puts "ruby closed with exit status: #{get_status.exitstatus}"
  end
end

EventMachine.run{
  @callback = EventMachine.Callback{|response| pp response}
  EventMachine.popen("curl -d 'track=AOL' http://stream.twitter.com/1/statuses/filter.json -unewfront:Turtlepizza", TweetHandler)
}