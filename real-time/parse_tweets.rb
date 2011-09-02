# http://web.media.mit.edu/~lieber/Publications/NLP4NLP.pdf
# wordnet db installed

@tweets = [
"RT @tattoochef: @rhodri Once got a warning from AOL because my son (9) and nephew (10) had called someone a 'smellyfaced cockmaster' in  ...",
"Florida Waitress Repays Bad Tippers By Stealing Credit-Card Info http://t.co/mqGaKEZ via @AOL",
"Dixon pulls away to win Mid-Ohio IndyCar http://aol.it/nQMle3",
"http://t.co/QFBVLZq Lady Gaga Cured Her Meat Dress 'Like Prosciutto' - AOL Music (blog)",
"RT @RubyScherzer: @GoKennyGo Hello gals take a look at this Lady Gaga personal email at http://t.co/OkuYSGM // Choke on her Disco Stick.",
"I liked a @YouTube video http://youtu.be/qrO4YZeyl0I?a Lady Gaga - Bad Romance",
"MY PS3 controller's analog stick is messed up!!!!!!!!!!!!!!!!!!!!! IT'S THE END OF THE WORLD!!!!!!!!!!!!!!!!!!!!!!!!",
"http://t.co/fNAsls4 Seinfeld Shower Computer Printer Hunting AOL Credit Card George Clooney Poker",
"http://t.co/Ce7JLT7 Nintendo Chevrolet Truck Computing Technology Angelina Jolie Relationship Lingerie"
]

@search_words = ['AOL','Huffington Post','Tech Crunch','Joystiq']
@most_common_words = ['the','because','of','to','and','a','in','is','it','you','that','he','was','for','on','are','with','as','I','his','they','be','at','one','have','this','from','or','had','by','not','but','some','what','there','we','can','out','other','were','all','your','when','up','use','word','how','said','an','each','she','which','do','their','time','if','will','way','about','many','then','them','would','write','like','so','these','her','long','make','thing','see','him','two','has','look','more','day','could','go','come','did','my','sound','no','most','number','who','over','water','than','call','first','may','down','side','been','now','find','any','new','part','take','get','place','made','live','where','after','back','little','only','round','man','year','came','show','every','good','me','give','our','under']
@common_words = ['stop','few','life','real','night','close','press','while','run','late','left','draw','sea','far','saw','story','might','start','hard','slice','cross','tree','city','between','door','last','never','eye','keep','let','thought','four','sun','food','cover','plant','learn','still','study','grow','school','answer','found','country','should','page','own','stand','head','father','earth','self','build','near','world','mother','point','animal','again','us','try','picture','house','need','off','kind','light','went','change','men','ask','why','act','such','high','big','must','here','land','even','add','spell','large','port','hand','read','home','put','end','small','play','also','well','air','want','three','set','sentence','tell','does','too','old','boy','right','move','differ','mean','same','cause','turn','before','line','low','help','say','think','great','much','form','just','through','very','name','liked','hello']
@less_common_words = ['open','seem','together','next','white','children','begin','got','walk','example','ease','paper','often','always','music','those','both','mark','book','letter','until','mile','river','car','feet','care','second','group','carry','took','rain','eat','room','friend','began','idea','fish','mountain','north','once','base','hear','horse','cut','sure','watch','color','face','wood','main','enough','plain','girl','usual','young','ready','above','ever','red','list','though','feel','talk','bird','soon','body','dog','family','direct','pose','leave','song','measure','state','product','black','short','numeral','class','wind','question','happen','complete','ship','area','half','rock','order','fire','south','problem','piece','told','knew','pass','farm','top','whole','king','size','heard','best','hour','better','true','during','hundred','am','remember','step','early','hold','west','ground','interest','reach','fast','five','sing','listen','six','table','travel','less','morning']
@lesser_common_words = ['ten','simple','several','vowel','toward','war','lay','against','pattern','slow','center','love','person','money','serve','appear','road','map','science','rule','govern','pull','cold','notice','voice','fall','power','town','fine','certain','fly','unit','lead','cry','dark','machine','note','wait','plan','figure','star','box','noun','field','rest','correct','able','pound','done','beauty','drive','stood','contain','front','teach','week','final','gave','green','oh','quick','develop','sleep','warm','free','minute','strong','special','mind','behind','clear','tail','produce','fact','street','inch','lot','nothing','course','stay','wheel','full','force','blue','object','decide','surface','deep','moon','island','foot','yet','busy','test','record','boat','common','gold','possible','plane','age','dry','wonder','laugh','thousand','ago','ran','check','game','shape','yes','hot','miss','brought','heat','snow','bed','bring','sit','perhaps','fill','east','weight','language','among']

@words = {}
@users = {}
@urls = {}

def parse_tweet(tweet)
  
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
  
  @search_words.each {|s_word|
    tweet = tweet.gsub(s_word.downcase,"")
    tweet = tweet.gsub(s_word.upcase,"")
    tweet = tweet.gsub(s_word,"")
  }
  
  # split words in tweet on space
  words = tweet.split(/\s/)
  
  # check important words
  view_important(words)
  
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
      
      unless @users.has_key?(word)
        @users.store(word,1)
      else
        count = @users[word]
        count += 1
        #puts "Count is now #{count.to_s}"
        @users[word] = count
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
      
      unless @urls.has_key?(word)
        @urls.store(word,1)
      else
        @urls[word] = (@urls[word] += 1)
      end
      
      #puts "***************************"
    else
      
      #store local words
      unless tmp_words.has_key?(word)
        tmp_words.store(word,1)
      else
        tmp_words[word] = (tmp_words[word] += 1)
      end
      
      unless @words.has_key?(word)
        @words.store(word,1) unless word.length <= 1
      else
        count = @words[word]
        count += 1
        @words[word] = count
        #puts @words[word].inspect
      end
      
    end
    
  }
  
  # return parsed tweet
  tweet = {:words => tmp_words, :users => tmp_users, :urls => tmp_urls, :retweet => retweet}
  
  tmp_words = nil
  tmp_users = nil
  tmp_urls = nil
  
  return tweet
  
end

def view_important(list)
  importants = []
  called_out = []
  
  list.each{|word|
    
    unless word.length < 1
      #word = word.downcase
      block = false
      # check if word ends in exclimation point
      
      if word.match(/([A-Za-z]*)!/)
        puts "Word ends with exclimation point. Seems interesting #{word.to_s}"
        called_out << word unless called_out.include? word
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
        if @most_common_words.include? word.downcase
          #puts "Word is most common: #{word.to_s}"
        elsif @common_words.include? word.downcase
          #puts "Word is common: #{word.to_s}"
        elsif @less_common_words.include? word.downcase
          #puts "Word is less common #{word.to_s}"
        elsif @lesser_common_words.include? word.downcase
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
  puts "Called Out from Tweet: #{called_out.inspect}"
  
end

def flow &block
  block.call
  #puts @words.inspect
  #puts @users.inspect
  #puts @urls.inspect
end

flow { @tweets.each{|t| 
  parse_tweet(t) 
  } 
}