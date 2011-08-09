module Parser
  
  def self.grab_tweet(tweet)
    puts "Rate Limit Error: " if tweet == "Easy there, Turbo. Too many requests recently. Enhance your calm."
    
    begin
      tweet = JSON.parse(tweet)
      unless tweet['text'].nil?
        parse_tweet = WordParser.new({:tweet =>tweet['text']})
        search_terms = parse_tweet.grab_important_words
        # search for image based on 
        puts "SEARCH FOR IMAGE: #{search_terms.join(' ')}"
        
        search = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari'}
        result = search.get("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+CGI.escape(search_terms.join(' ')))
        # get images
        result = JSON.parse(result.body)
        
        @urls = []
        result["responseData"]["results"].each {|response|
          @urls << response["unescapedUrl"]
        }
        
        if @urls.size > 1
          puts "image for tweet: #{@urls[0].to_s}"
        end
        
        search = nil
        
      end
      #pp tweet
    rescue JSON::ParserError => e
      puts "message: #{tweet.to_s}"
      puts "Don't parse non JSON. Wasted your time: #{e.inspect}"
      #return 
    rescue NoMethodError => e
      puts "Errror: #{e.inspect}"
      #return
    end
    
    return unless tweet['text']
    puts "====================================="
    #puts 
    puts "@#{tweet['user']['screen_name']}: #{tweet['text']}"
    puts "Hashtags: #{tweet['entities']['hashtags'].inspect}"
    #puts
    puts "====================================="
    
    #show_good_words
    
  end
end