#!/usr/bin/ruby

require 'socket'

@host = '127.0.0.1'
@port = 7000

server = TCPServer.new(@host,@port)

accepts = server.accept
accepts.puts "Hello"
accepts.close