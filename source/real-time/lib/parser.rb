class Parser
  
  def initialize(tweet)
    grab_tweet(tweet)
  end
  
  def grab_tweet(tweet)
    puts "Rate Limit Error: " if tweet == "Easy there, Turbo. Too many requests recently. Enhance your calm."
    
    begin
      tweet = JSON.parse(tweet)
      unless tweet['text'].nil?
        prep_data(tweet)
      end
      #pp tweet
    rescue JSON::ParserError => e
      puts "message: #{tweet.to_s}"
      puts "Don't parse non JSON. Wasted your time: #{e.inspect}"
      #return 
    #rescue NoMethodError => e
      #puts "Errror: #{e.inspect}"
      #return
    end
    
    return unless tweet['text']
    
    # show in stdout on server
    puts "====================================="
    #puts 
    puts "@#{tweet['user']['screen_name']}: #{tweet['text']}"
    puts "Hashtags: #{tweet['entities']['hashtags'].inspect}"
    #puts
    puts "====================================="
    #show_good_words
  end
  
  # take tweet json
  # send to parser
  # grab image
  # send to send_result
  def prep_data(tweet_data)
    parse_tweet = WordParser.new({:tweet =>tweet_data['text']})
    search_terms = parse_tweet.grab_important_words
    # search for image based on 
    puts "SEARCH FOR IMAGE: #{search_terms.join(' ')}"
    
    search = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari'}
    result = search.get("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+CGI.escape(search_terms.join(' ')))
    # get images
    result = JSON.parse(result.body)
    
    @urls = []
    #puts result.inspect
    
    begin
      result["responseData"]["results"].each {|response|
        @urls << response["unescapedUrl"]
      }
    rescue
      puts "error"
    end
    
    
    # form to send to web socket
    data= Hashie::Mash.new
    data.from = tweet_data['user']['screen_name']
    data.tweet = tweet_data['text']
    if @urls.size > 1
      puts "image for tweet: #{@urls[0].to_s}"
      data.image = @urls[0].to_s
    else
      data.image = ""
    end
    data.tags = search_terms.join(" ")
    data.important = search_terms[0]
    
    send_result(data)
    
    search = nil
  end
  
  # Send parsed tweet to websocket
  def send_result(data)
    #begin
      #jdata = data.to_json
      html = "<div class='tweet'><div class='t_tweet'><img src='#{data.image}' width='46' height='46' class='t_img'/><span class='from_user'>@#{data.from.to_s}</span><span class='tweet_data'>#{data.tweet.to_s}</span></div><div id='tags_and_importants'><span class='tags'> ( #{data.tags.to_s} ) </span><span class='important'><strong>#{data.important.to_s}</strong></span><div class='clearfix'></div></div>"
      $new_messages.call(html)
    #rescue
      #puts "can't use eventmachine callback"
    #end
  end
  
  
end