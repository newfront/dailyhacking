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