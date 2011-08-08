require 'mongoid'

# Tweets stored in memory

class Tweet
  
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in :tweets
  
  field :twitter_handle, :type =>String
  field :tweet, :type => String
  field :is_retweet => Integer #0,1
  field :search_terms => String
  field :created_at, :type => Time
  field :updated_at, :type => Time
  
  before_save do
    # parse sentances
  end
  
end

class Tags
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in :tweets
  
  field :tag, :type => String
  field :weight, :type => Integer
  field :is_hash_tag, :type => Integer #0,1
  field :created_at, :type => Time
  field :completed_at, :type => Time
  
end