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

require "hashie"
require "json"
require "pp"
# abstract base class Formatter
class Formatter
  def format
    raise "Abstract method. need to override in child class"
  end
end

# Create a Formatter for EventSource
class EventSourceFormatter < Formatter
  
  def format(notification)
    # notification is an object of Hashie Type
    # {:type=>"user", :content=>"{'content': 'Hello You', 'url': 'http://google.com'}
    # event source format
    # data: content.chunk\n
    # data: content.chunk\n
    # data: content.chunk\n
    
    #head = ""
    #message = ""
    message = "event: #{notification[:event]}\n"
    message << "id: #{notification[:id]}\n" unless notification[:id].nil?
    message << "retry: #{notification[:retry]}\n" unless notification[:retry].nil?
    
    begin
      data = JSON.parse(notification[:data])
      message << "data: {\n"
      @count = data.size - 1
      data.each {|key, value|
        message << "data: \"#{key}\": \"#{value}\""
        message << "," unless @count <= 0
        message << "\n"
        @count -= 1
      }
      message << "data: }\n\n"
    rescue
      # JSONParseError
      message << "data: #{key} - #{val}\n\n"
    end
    message
  end
  
end

#formatter = EventSourceFormatter.new
# notification

#data = {}
#data[:message] = "Hello User"
#data[:url] = "http://google.com"

#notification = {:event=>"user", :data=> data.to_json, :id=>"23657777", :retry => 10000}

#puts formatter.format(notification)