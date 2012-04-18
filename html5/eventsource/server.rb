#!/usr/bin/env ruby
require "sinatra/async"
require "em-http-request"
require "thin"
require "pp"
require "json"
require "yaml"
require "hashie"

$: << File.join(File.dirname(__FILE__), "")

require "libs/formatter"
require "libs/registry.rb"
require "libs/modules/notification"

# Setup Configuration
server_config = YAML.load_file("config/server.yml")

pp server_config

# Sinatra Push Server
class AsyncPush < Sinatra::Base
  register Sinatra::Async
  
  use Rack::MethodOverride
  set :sessions, true
  set :logging, true
  
  @@registry = Registry.new
  
  # connect and pull your messages using internal javascript
  get '/' do
    erb :index
  end
  
  get '/notifications/list' do
    redirect '/login/system' unless !session[:user].nil?
    
    headers \
    "Content-Type" => "application/json",
    "Cache-Control" => "no-cache"
    
    message = {}
    message[:type] = "list"
    message[:content] = "You are looking to view your notifications list"
    body message.to_json
    
  end
  
  get '/notification/:uuid/new' do
    # check if user exists
    if @@registry.user? params[:uuid]
      puts "adding new notification"
      # store user object in temp variable
      user = @@registry.user params[:uuid]
      # now dispatch a random message
      data = {}
      data[:message] = "System dispatch: #{Time.new}"
      data[:url] = "http://yahoo.com"
      user.notifications << {:event=>"user", :data=> data.to_json} # push new notification to queue
    else
      "can't add notification since user doesn't exist"
    end
  end
  
  get '/session' do
    pp session
    unless session[:user].nil?
      puts session[:user].name
      puts session[:user].start
      "user: #{session[:user].name}, uuid: #{session[:user].uuid}"
    else
      puts "no user"
    end
  end
  
  get '/login/:user' do
    
    if session[:user].nil?
      # add user to session
      session[:user] = Hashie::Mash.new
      session[:user].name = params[:user]
      session[:user].start = Time.new
    
      # register user
      user = @@registry.register({
        :name => session[:user].name,
        :uuid => (Unique.new).unique,
        :type => "user"
      })
      
      session[:user].uuid = user.uuid
      
      puts "Registered a new User..."
      puts user
      redirect "/polling/#{session[:user].name}"
    else
      redirect "/"
    end
  end
  
  # EventSource API stated that http chunked can cause issues with EventSource, using standard async-get
  get '/polling/:user' do
    
    if session[:user].nil?
      puts "You don't have a current session on notifications server"
      puts "redirecting you to create a mock session"
      redirect "/login/#{params[:user]}"
    end
    
    headers \
    "Content-Type" => "text/event-stream",
    "Cache-Control" => "no-cache"
    puts session[:user].uuid
    unless !@@registry.user? session[:user].uuid
      user = @@registry.user session[:user].uuid
    else
      body {"data: Error on server, Lost your Session\n\n"}
    end
    
    if user.notifications.size > 0
      puts user
      puts user.notifications
      data = user.notifications.next(true)
    else
      #data = "data: no new messages\nretry: 5000\n\n"
      data = user.notifications.next
    end
    puts data
    body {data}
  end
  
end