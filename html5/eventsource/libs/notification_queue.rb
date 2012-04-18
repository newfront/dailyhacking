$: << File.join(File.dirname(__FILE__), "")
require "hashie"
require "modules/notification"
require "modules/crypto/universal_unique"
require "formatter"
include Notification
include Crypto::Universal
# NotificationQueue class
class NotificationsQueue
  
  attr_writer :uuid
  attr_accessor :formatter, :last_message
  # builds an instance of NotificationsQueue
  # sets up a queue
  def initialize(params={})
    unless !params[:uuid].nil?
      raise "ArgumentError: You need to provide a uuid to instantiate this class"
    end
    @uuid = params[:uuid]
    @queue = []
    @formatter = params[:formatter] ? params[:formatter] : EventSourceFormatter.new
    @MAX_RETRY = 50000
    @retry = 5000
  end
  
  # sets up a method to retrieve the next notification from the queue
  def next (format=false)
    unless !@queue.empty?
      data = "data: no new messages\nretry: #{@retry}\n\n"
      unless @MAX_RETRY < @retry+10000
        @retry += 10000
      end
      return data
    end
    # if we are not to format the message, return the object, otherwise format the object and return it
    !format ? @queue.shift : format(@queue.shift)
  end
  
  # get the size of the queue
  def size
    return @queue.size
  end
  
  # add a message into the queue
  def << notification
    return false unless notification.is_a? Hash
    notification[:id] = (Unique.new).unique
    @retry = 5000
    notification[:retry] = @retry
    @queue << notification
    @last_message = Time.new
  end
  
  def time_since_last_notification
    return false unless !@last_message.nil?
    return Time.new - @last_message
  end
  
  private
  
  def format(notification)
    # format the notification
    @formatter.format(notification)
  end
  
end

# Example Usage
# self.write(type, content, params={})
#puts Notification::write("user", "Hello User")

#notifications_queue = NotificationsQueue.new({:uuid => "xx3388-pss34fff"})

#unless !notifications_queue.registered?
  #puts "registered"
  # view current formatter
  #puts notifications_queue.formatter
  # check on the notifications queue. should be empty, so we should get a string returned
  #puts notifications_queue.next.empty? #true
  
  # add a new notification
#  data = {}
#  data[:message] = "Hello User"
#  data[:url] = "http://google.com"
#  notifications_queue << {:event=>"user", :data=> data.to_json}
  
  # notifications_queue should now have a single notification
  #puts notifications_queue.size # 1
  
  # view first notification
#  puts "Notification\n"
#  puts notifications_queue.next(true)
#  puts
#else
#  puts "not registered"
#end 