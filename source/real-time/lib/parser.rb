module Parser
  
  def self.parse_tweet(tweet)
    tmp_words = {}
    tmp_urls = {}
    tmp_users = {}
    
    # does it start with RT?
    retweet = false
    if tweet.match(/^(RT)/i)
      tweet = tweet.gsub(/^(RT )/i,"")
      retweet = true
    end 
    
    # grab words in quotes
    user_quoted_text = []
    matches = tweet.match(/(["|'](.*)['|"])/)
    if matches 
      #puts "#{matches[2].inspect}"
      user_quoted_text << matches[2] 
    end
    puts "User enclosed this in Quotes: #{user_quoted_text[0]}" if !user_quoted_text.empty?
    
    #@search_words.each {|s_word|
    #  tweet = tweet.gsub(s_word.downcase,"")
    #  tweet = tweet.gsub(s_word.upcase,"")
    #  tweet = tweet.gsub(s_word,"")
    #}
    
    # split words in tweet on space
    words = tweet.split(/\s/)
    
    # check important words, return hash
    importants = view_important(words)
    
    # count the words in the tweet
    # which words repeat? don't repeat
    words.each{|word|
      # check if the word is a twitter username
      if word.match(/@[A-Za-z0-9_]*/)
        #puts "**************************"
        #puts "\nFound Twitter User: #{word.to_s}\n"
        # store the twitter user in a hash with init count, unless already in hash
        
        # store users in temp
        unless tmp_users.has_key?(word)
          tmp_users.store(word,1)
        else
          tmp_users[word] = (tmp_users[word] += 1)
        end
      
        unless $users.has_key?(word)
          $users.store(word,1)
        else
          count = $users[word]
          count += 1
          #puts "Count is now #{count.to_s}"
          $users[word] = count
          #puts @users[word].inspect
        end 
        #puts "*************************"
      elsif word.match(/http:.*/i)
        #puts "***************************"
        #puts "URL: #{word.to_s}"
        
        # store temp url
        unless tmp_urls.has_key?(word)
          tmp_urls.store(word,1)
        else
          tmp_urls[word] = (tmp_urls[word] += 1)
        end
      
        unless $urls.has_key?(word)
          $urls.store(word,1)
        else
          $urls[word] = ($urls[word] += 1)
        end
        
        #puts "***************************"
      else
        #store local words
        unless tmp_words.has_key?(word)
          tmp_words.store(word,1)
        else
          tmp_words[word] = (tmp_words[word] += 1)
        end
        
        unless $words.has_key?(word)
          $words.store(word,1) unless word.length <= 1
        else
          count = $words[word]
          count += 1
          $words[word] = count
          #puts @words[word].inspect
        end
        
      end
    }
  
    # return parsed tweet
    tweet = {:words => tmp_words, :users => tmp_users, :urls => tmp_urls, :retweet => retweet}
    # return {:i_words => importants, :search => importants[0..1].join(" "), :call_outs => called_out}
    
    begin
      importants.store(:quoted => user_quoted_text[0]) unless user_quoted_text.empty?
    rescue
    end
    
    tweet = tweet.merge(importants)
    
    # clean up
    tmp_words = nil
    tmp_users = nil
    tmp_urls = nil
    return tweet
    end

  def self.view_important(list)
    importants = []
    called_out = []
  
    list.each{|word|
      word = word.gsub("#",'').gsub("$",'') # strip out hash tag or money
      unless word.length < 3
        #word = word.downcase
        block = false
        # check if word ends in exclimation point
        
        if word.match(/([A-Za-z]*)!/)
          puts "Word ends with exclimation point. Seems interesting #{word.to_s}"
          called_out << word.gsub("#",'').gsub("$",'') unless called_out.include? word 
        end
        
        # test against users
        if word.match(/@[A-Za-z0-9_]*/)
          #puts "just a user"
          block = true
        end
        
        # check if its a URL
        if word.match(/http:.*/i)
          #puts "just a url"
          block = true
        end
        
        # check against 4 common word lists
        # @most_common_words
        # @common_words
        # @less_common_words
        # @lesser_common_words
        unless block
          if $most_common_words.include? word.downcase
            #puts "Word is most common: #{word.to_s}"
          elsif $common_words.include? word.downcase
            #puts "Word is common: #{word.to_s}"
          elsif $less_common_words.include? word.downcase
            #puts "Word is less common #{word.to_s}"
          elsif $lesser_common_words.include? word.downcase
            #puts "Word is least common: #{word.to_s}"
          elsif word == word.upcase
            called_out << word unless called_out.include? word 
          else
            #puts "Word seems kind of important: #{word.to_s}"
            importants << word unless importants.include? word
          end
        end
      end
    }
    
    puts "Important Words from Tweet: #{importants.inspect}"
    
    # notion that important words will make good image (first few....)
    # google image seach api
    puts "Search For: #{importants[0..1].join(" ")}"
    puts "Called Out from Tweet: #{called_out.inspect}"
    return {:i_words => importants, :search => importants[0..1].join(" "), :call_outs => called_out}
  end

  def self.tweet_reduce
    # take a tweet
    # pass through @most_common_words filter
    # if words left, pass through @common_words filter
    # if words left, pass through @less_common_words filter
    # if words left, pass through @lesser_common_words filter
    
    # once we have passed through all filters, we should be left with uncommon words, peoples names, and expressions
    
  end

  def self.grab_tweet(tweet)
    puts "Rate Limit Error: " if tweet == "Easy there, Turbo. Too many requests recently. Enhance your calm."
    
    begin
      tweet = JSON.parse(tweet)
      unless tweet['text'].nil?
        parsed_tweet = Parser::parse_tweet(tweet['text'])
        puts "Tweet is parsed: #{parsed_tweet.inspect}"
        #Tweet is parsed: {
        #:words=>{"Falling"=>1, "Action:"=>1, "Best"=>1, "and"=>1, "Worst"=>1, "of"=>1, "UFC"=>1, "133"=>1}, 
        #:users=>{"@MMAFighting:"=>1, "(@benfowlkesmma)"=>1}, 
        #:urls=>{"http://t.co/rB95xee"=>1}, 
        #:retweet=>true, 
        #:i_words=>["Falling", "Action:", "Worst"], 
        #:search=>"Falling Action:", :call_outs=>["UFC", "133"]}
        #:quoted
        
        # grab the bigger words from quoted text
        begin
          quoted_terms_important = parsed_tweet[:quoted].split(" ").map {|word| word.length > 5 ? word : ""}.join(" ")
        rescue
          puts "Couldn't parse quote"
        end
        
        store = Tweet.new
        #:twitter_handle, :tweet, :is_retweet
        puts "User: @#{tweet['user']['screen_name']}"
        store[:twitter_handle] = tweet['user']['screen_name']
        store[:tweet] = tweet['text']
        store[:search_terms] = parsed_tweet[:search] << parsed_tweet[:call_outs].join(" ")
        if parsed_tweet[:retweet]
          store[:is_retweet] = 1
        else
          store[:is_retweet] = 0
        end 
        store.save
        
        # search for image based on 
        puts "SEARCH FOR IMAGE BASED ON: #{store[:search_terms]}"
        
        search = Mechanize.new {|agent| agent.user_agent_alias = 'Mac Safari'}
        result = search.get("http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+CGI.escape(store[:search_terms]))
        
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
        
        #begin
        #  parsed_tweet[:i_words].each {|tag|
        #    store.tags  Tag.new
        #    store.tags[:tag] = tag
        #    store.tags[:weight] = 1
        #    store.tags[:is_hash_tag] = 0
        #    store.tags.save 
        #  }
        #rescue
        #  puts "Couldn't store tags"
        #end
      end
      #pp tweet
    rescue JSON::ParserError => e
      puts "message: #{tweet.to_s}"
      puts "Don't parse non JSON. Wasted your time: #{e.inspect}"
      return 
    rescue NoMethodError => e
      puts "Errror: #{e.inspect}"
      return
    end
    
    return unless tweet['text']
    puts "====================================="
    #puts 
    puts "@#{tweet['user']['screen_name']}: #{tweet['text']}"
    puts "Hashtags: #{tweet['entities']['hashtags'].inspect}"
    #puts
    puts "====================================="
  end
end