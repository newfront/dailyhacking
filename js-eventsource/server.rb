#!/usr/bin/env ruby

=begin
Copyright (c) 2012, Yahoo! Inc.  All rights reserved.

Redistribution and use of this software in source and binary forms, 
with or without modification, are permitted provided that the following 
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of Yahoo! Inc. nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of Yahoo! Inc.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS 
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

require "sinatra/async"
require "em-http-request"
require "thin"
require "pp"
require "json"
require "yaml"
require "hashie"

$: << File.join(File.dirname(__FILE__), "")

require File.join(File.dirname(__FILE__),"libs/formatter")
require File.join(File.dirname(__FILE__),"libs/registry.rb")
require File.join(File.dirname(__FILE__),"libs/modules/notification")

# Setup Configuration
server_config = YAML.load_file(File.join(File.dirname(__FILE__),"config/server.yml"))

# Sinatra Push Server
class AsyncPush < Sinatra::Base
  register Sinatra::Async
  
  use Rack::MethodOverride
  set :sessions, true
  set :logging, true
  
  @@registry = Registry.new #register single shared instance of registry
  
  # connect and pull your messages using internal javascript
  get '/user/:user' do
    redirect '/' unless !params[:user].nil?
    @user = params[:user] unless params[:user].nil?
    erb :index
  end
  
  get '/' do
    @user = "scott"
    erb :index
  end
  
  ########################################
  # Notifications Service
  
  get '/notification/:uuid/new' do
    @uuid = params[:uuid]
    erb "notification/create".to_sym
  end
  
  post '/notification/create' do
    puts params
    message = params[:message]
    
    puts "posting new notification"
    # store user object in temp variable
    
    begin
      user = @@registry.user params[:uuid]
      # now dispatch a random message
      data = {}
      data[:message] = params[:message]
      data[:url] = ""
      user.notifications << {:event=>"user", :data=> data.to_json} # push new notification to queue
    rescue
      puts "oppps. user probably doesn't exist"
    end
    redirect '/admin/list'
  end
  
  # EventSource API stated that http chunked can cause issues with EventSource, using standard async-get
  get '/notifications/:user' do
    
    if session[:user].nil?
      puts "You don't have a current session on notifications server"
      puts "redirecting you to create a mock session"
      redirect "/login/#{params[:user]}"
    end
    
    headers \
    "Content-Type" => "text/event-stream",
    "Cache-Control" => "no-cache"
    #puts session[:user].uuid
    unless !@@registry.user? session[:user].uuid
      user = @@registry.user session[:user].uuid
    else
      body {"data: Error on server, Lost your Session\n\n"}
    end
    
    if user.notifications.size > 0
      #puts user
      #puts user.notifications
      data = user.notifications.next(true)
    else
      #data = "data: no new messages\nretry: 5000\n\n"
      data = user.notifications.next
    end
    puts data
    body {data}
  end
  
  #######################################################
  # Session Service
  
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
      redirect "/notifications/#{session[:user].name}"
    else
      redirect "/"
    end
  end
  
  ##############################################################
  # Admin Stuff
  
  get '/admin/list' do
    @html = "<ul>"
    @@registry.list do |data|
      @html << "<li>User (#{data.uuid}): #{data.name}: <a href='/notification/#{data.uuid}/new'>Write Notification</a></li>"
    end
    @html << "</ul>"
    erb "admin/list".to_sym
  end
  
end