#!/usr/bin/env ruby

# server.rb

require 'sinatra/base'
require 'json'
require 'hashie'
require 'yaml'
require 'pp'


class App < Sinatra::Base
	use Rack::MethodOverride
	set :public_folder, File.dirname(__FILE__) + "/public"

	def self.http_options(path, opts={}, &block)
		route 'OPTIONS', path, opts, &block
	end

	# inject into all responses
	before do
		response.headers['Access-Control-Allow-Origin'] = "requested-domain.com"
		response.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
		response.headers['Access-Control-Allow-Credentials'] = 'true'
		response.headers['Access-Control-Allow-Headers'] = 'origin, content-type'
		response.headers['Access-Control-Expose-Headers'] = 'cache-control, content-type'
	end

	# respond to OPTIONS http inquiry
	http_options '/' do
		puts "in OPTIONS default"
		puts @request
		halt 200
	end

	options '/' do
		puts "in OPTIONS override one"
		puts @request
		halt 200
	end

	options '/user/info' do
		puts "in OPTIONS"
		pp @request
		halt 200
	end

	get '/' do
		puts "on main / get for server"

		@title = "CORS LAUNCHER"
		@header = "<h3>CORS Example Server</h3>"
		@markup = "<p>Make a post request via AJAX to /user/info from another domain</p>"
		erb :index
	end

	post '/user/info' do
		response.headers['Content-Type'] = "application/json"

		resp = Hashie::Mash.new
		resp.message = "Wicked Cool Success"
		resp.code = 200

		resp.to_json
		
	end
end

App.run!({:port => 8080})