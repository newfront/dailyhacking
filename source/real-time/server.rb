#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), "")
$: << $APP_ROOT = File.expand_path(File.dirname(__FILE__))

# grab dependencies
requires = ['em-websocket','cgi','em-http-request','sinatra/base','thin','logger','hashie','mechanize','socket','pp','json']
requires.each {|dependency| require dependency}

# include our parser lib and connection lib
require 'lib/parser'
require 'lib/word_parser'
require 'lib/connection'

# Grab Model Files
require 'model/tweet'

# add sinatra web server
require 'sinatra/base'
require 'erb'

@params = ARGV # grab username and password (twitter username/password) from command line

# NOTE: you have to add your twitter username and password, or this won't run
$user = {
  :username => @params[0].nil? ? "twitter_username" : @params[0],
  :password => @params[1].nil? ? "twitter_password" : @params[1],
  :google_dev_key => "ABQIAAAAqj2FkdNbZi_ZKy1fY_HdjxQsPFBHlSdy9MSZLoC4ErdaOPqPGhSsI3FcfI7uPySPy7zgD5eo88rAWw",
  :google_dev_url => "http://gravitateapp.com"
}

$db = {
  :name => "tweetdata"
}

@host = '127.0.0.1'
@port = 9000

# open up stream to Twitter (pipe)
WAIT_TIME_DEAFULT = 10
@wait_time = WAIT_TIME_DEAFULT # initially start at 4 minutes

def stream_request
  puts "==================================\n\n"
  puts "Start Grabing Info from the Stream"
  
  @request_url = 'http://stream.twitter.com/1/statuses/filter.json'
  
  #(Note) the more values in the track= the less things actually show up
  
  http = EventMachine::HttpRequest.new(@request_url).post :head => {'Authorization'=> [$user[:username],$user[:password]],'Content-Type'=>"application/x-www-form-urlencoded"}, :body => "track=Editions,webaim,joystiq,myAOL"
  #puts http.inspect
  buffer = ""
  
  # Grab initial headers
  http.headers {
    #pp http.response_header.status
    if http.response_header.status.to_i == 401
      raise "Error. Authentication Required. Please add your username and password to the command line. eg. ruby server.rb twitter_username twitter_password"
    end
  }
  
  # Grab stream as it becomes available
  http.stream do |chunk|
    buffer += chunk
    while line = buffer.slice!(/.+\r?\n/)
      Parser.new(line) unless line.bytesize < 10
    end
    
  end
  
  # Stream is now complete, issue reconnection
  http.callback {
  #  pp http.response_header.status
  #  pp http.response
    
    puts "connection closed by Twitter. Reconnect"
    
    if http.response_header.status == 420
      @wait_time += 60
      $new_messages.call("Easy there, Turbo. Too many requests recently. Enhance your calm. (Have to wait #{@wait_time.to_s})")
    elsif http.response_header.status == 200
      @wait_time = 10
    else
      @wait_time = WAIT_TIME_DEAFULT
    end
    
    puts "Next run in #{@wait_time.to_s}"
    EventMachine::Timer.new(@wait_time) do
      stream_request
    end
    
  }
  
  # Error connecting, try again
  http.errback {
    puts "error on that one. try again"
    #$new_messages.call("Error on HTTP Stream. Reconnecting")
    EventMachine::Timer.new(@wait_time) do
      stream_request
    end
  }
  
end


EM.run do
  
  $ws_connections = []
  
  puts "Twitter Streaming in 3 seconds"
  #Connection::MongoDB::connect($db[:name])
  
  $new_messages = EM.Callback{|msg| 
    puts (msg) 
    puts $ws_connections.size.to_s
    unless $ws_connections.size == 0
      $ws_connections.each {|connection|
        connection.send(msg)
      }
    end
  }
  
  # Setup Server Here
  # bind via websocket
  # send data back to users
  
  # initiate polling on streaming twitter api
  stream_request
  
  EventMachine::WebSocket.start(:host => '0.0.0.0', :port => @port) do |ws|
    
    ws.onopen {
      puts "WebSocket connection open"
      # publish message to the client
      ws.send "connected"
      @user = ws
      $ws_connections << ws
    }
    
    ws.onclose { 
      puts "Connection closed" 
      $ws_connections.delete(ws)
    }
    
    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      puts msg.inspect
      #ws.send "#{msg}"
    }
    
  end
  
  class App < Sinatra::Base
    use Rack::MethodOverride
    set :port => 3000
    set :host => 'localhost'
    #set :sessions, true
    #set :logging, true
    set :public, File.dirname(__FILE__) + '/public'
    
    get '/' do
      @title = "Live Stream"
      @year = Time.new.year
      erb :index
    end
  end
  
  App.run!({:port => 3000})

  #n = 0
  #timer = EventMachine::PeriodicTimer.new(5) do
  #   $new_messages.call("running from eventmachine")
  #   timer.cancel if (n+=1) > 5
  #end
  
end

puts "EventMachine has stopped. Live Stream is no more"