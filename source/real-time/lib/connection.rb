module Connection
  
  # connection related stuff
  module MongoDB
    # Connects to a MongoDB Server
    # @param [Hashie::Mash] data is a collection of system wide configs, or run-time connection config
    def self::connect name
      
      # connect to MongoDB server
      Mongoid.configure do |config|
        config.master = Mongo::Connection.new.db(name)
      end
      
      puts "Mongodb Connected"
      
    end
  end
  
end