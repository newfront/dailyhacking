$: << File.join(File.dirname(__FILE__), "")
require "hashie"
require "notification_queue"
require "modules/crypto/universal_unique"
include Crypto::Universal
# NotificationRegistry
class Registry
  
  # constructor for new registry
  def initialize
    @registry = Hashie::Mash.new
    @registry.users = Hashie::Mash.new
  end
  
  # register command will take type (user, system, etc) - which maps to @registry[type]
  # register will also take a params ball
  def register (params={})
    
    raise "ParameterError" unless !params.empty?
    raise "ArgumentError" unless !params[:type].nil? # example: {:type=>"user"}
    
    case params[:type]
      when "user"
        test = validate_user(params) #returns true if no errors, returns Array of errors if errors
        
        unless !test.is_a? TrueClass
          @registry.users[params[:uuid]] = Hashie::Mash.new
          @registry.users[params[:uuid]].name = params[:name]
          @registry.users[params[:uuid]].notifications = NotificationsQueue.new({:uuid => params[:uuid]})
          @registry.users[params[:uuid]].notifiable = true
          @registry.users[params[:uuid]].uuid = params[:uuid]
          return @registry.users[params[:uuid]]
        else
          raise "ArgumentError: #{test.join("\n")}"
        end
      
      when "system" then "system"
    else
      raise "ArgumentError: Registry.register requires type to be either user or system"
    end
    
  end
  
  # catch-all update for user
  def update_user (uuid, type, payload)
    return false unless @registry.users.has_key? uuid
    @registry.users[uuid][type] = payload
  end
  
  def list(output=true, &block)
    @registry.users.each {|uuid, data| 
      puts "user: uuid - #{uuid} \n name: #{data.name}\n notifiable: #{data.notifiable}"
      yield(data) unless !block_given?
    }
  end
  
  # is user registered?
  def user? uuid
    return true unless @registry.users[uuid].nil?
    return false
  end
  
  # get the user object
  def user uuid
    return @registry.users[uuid]
  end
  
  private
  
  # ensure the user params pass correctly
  def validate_user params
    error = false
    errors = []
    
    unless !params[:name].nil?
      error = true
      errors << "Missing params[:name]"
    end
    
    unless !params[:uuid].nil?
      error = true
      errors << "Missing params[:uuid]"
    end
    
    return errors unless !error
    true
  end
  
end

=begin
registry = Registry.new
# pass case
user = registry.register({
  :name => "Scott Haines",
  :uuid => (Unique.new).unique,
  :type => "user"
})

if registry.user? user.uuid
  puts "Found User"
  user = registry.user user.uuid
  if user.notifiable
    puts "User can receive notifications"
    # test adding a notification
    data = {}
    data[:message] = "Hello User"
    data[:url] = "http://google.com"
    user.notifications << {:event=>"user", :data=> data.to_json, :id=>"23657777", :retry => 10000}
    if user.notifications.size > 0
      puts "User can be sent notification"
      puts user.notifications.next(true)
    else 
      puts "User can't be sent a notification. No messages"
    end
    
  else
    puts "User can't receive notifications"
  end
else
  puts "Couldn't Find User"
end
# fail case
#registry.register("user", {
#  :name => "Scott Haines",
#  :uuid => "xx3388-pss34fff"
#})
#puts registry.list

# update user to be notifiable
#registry.update_user("xx3388-pss34fff", "notifiable", true)
#registry.update_user("xx3388-pss34fff", "notifications_queue", "")

#puts registry.list
=end
