#!/usr/bin/env ruby

# curl -d "track=AOL,'editions ipad','america online'" http://stream.twitter.com/1/statuses/filter.json -u<un>:<pw>
#$: << 'lib' << '../lib'
$: << File.join(File.dirname(__FILE__), "")
$: << $APP_ROOT = File.expand_path(File.dirname(__FILE__))

require 'hashie'
require 'eventmachine'
# gem install em-http-request --pre (to get middleware)
# gem install yajl-ruby
require 'em-http'
require 'em-http/middleware/oauth'
require 'em-http/middleware/json_response'
require 'em-websocket'
require 'json'
require 'yajl'
require 'yaml'
require 'pp'

# connect to mongodb
# store each tweet into a queue
# grab words from each tweet, generate word count


@follow_twitter_handles = ["@aol","@aoltravel","@editions"]

#["place", nil]
#["text", "Tips for traveling (or not) with the iPad: \n\t\n\n\tGary Arndt has written an interesting blog post about traveling ... http://aol.it/ooqRJj"]
#["favorited", false]
#["truncated", false]
#["in_reply_to_status_id_str", nil]
#["created_at", "Sun Aug 07 22:37:22 +0000 2011"]
#["geo", nil]
#["in_reply_to_screen_name", nil]
#["in_reply_to_user_id", nil]
#["source", "<a href=\"http://twitterfeed.com\" rel=\"nofollow\">twitterfeed</a>"]
#["in_reply_to_user_id_str", nil]
#["in_reply_to_status_id", nil]
#["contributors", nil]
#["retweeted", false]
#["coordinates", nil]
#["activities", {"favoriters"=>[], "favoriters_count"=>"0", "repliers"=>[], "repliers_count"=>"0", "retweeters_count"=>"0", "retweeters"=>[]}]
#["user", {"favourites_count"=>34, "location"=>"55.921999,-4.447519", "follow_request_sent"=>nil, "contributors_enabled"=>false, "profile_link_color"=>"0084B4", "followers_count"=>302, "following"=>nil, "profile_sidebar_border_color"=>"C0DEED", "time_zone"=>"Edinburgh", "created_at"=>"Thu Jul 19 10:15:09 +0000 2007", "friends_count"=>551, "description"=>"Enterprise Security Architect, technology enthusiast, Apple geek, amateur photographer, father of 2, patience of a saint!", "is_translator"=>false, "profile_use_background_image"=>true, "default_profile"=>true, "listed_count"=>11, "profile_background_color"=>"C0DEED", "show_all_inline_media"=>false, "geo_enabled"=>true, "profile_background_image_url_https"=>"https://si0.twimg.com/images/themes/theme1/bg.png", "profile_background_image_url"=>"http://a0.twimg.com/images/themes/theme1/bg.png", "protected"=>false, "verified"=>false, "profile_text_color"=>"333333", "url"=>"http://alexwaddell.co.uk", "profile_image_url"=>"http://a1.twimg.com/profile_images/482004362/IMG_0608_normal.jpg", "name"=>"Alex Waddell", "default_profile_image"=>false, "statuses_count"=>2932, "notifications"=>nil, "profile_sidebar_fill_color"=>"DDEEF6", "profile_image_url_https"=>"https://si0.twimg.com/profile_images/482004362/IMG_0608_normal.jpg", "id"=>7582812, "id_str"=>"7582812", "lang"=>"en", "profile_background_tile"=>false, "utc_offset"=>0, "screen_name"=>"alexwaddell"}]
#["retweet_count", 0]
#["id", 100334747837931521]
#["possibly_sensitive", false]
#["id_str", "100334747837931521"]
#["entities", {"urls"=>[{"indices"=>[116, 136], "url"=>"http://aol.it/ooqRJj", "expanded_url"=>nil}], "user_mentions"=>[], "hashtags"=>[]}]

@most_common_words = ['the','of','to','and','a','in','is','it','you','that','he','was','for','on','are','with','as','I','his','they','be','at','one','have','this','from','or','had','by','not','but','some','what','there','we','can','out','other','were','all','your','when','up','use','word','how','said','an','each','she','which','do','their','time','if','will','way','about','many','then','them','would','write','like','so','these','her','long','make','thing','see','him','two','has','look','more','day','could','go','come','did','my','sound','no','most','number','who','over','water','than','call','first','may','down','side','been','now','find','any','new','part','take','get','place','made','live','where','after','back','little','only','round','man','year','came','show','every','good','me','give','our','under']
@common_words = ['stop','few','life','real','night','close','press','while','run','late','left','draw','sea','far','saw','story','might','start','hard','slice','cross','tree','city','between','door','last','never','eye','keep','let','thought','four','sun','food','cover','plant','learn','still','study','grow','school','answer','found','country','should','page','own','stand','head','father','earth','self','build','near','world','mother','point','animal','again','us','try','picture','house','need','off','kind','light','went','change','men','ask','why','act','such','high','big','must','here','land','even','add','spell','large','port','hand','read','home','put','end','small','play','also','well','air','want','three','set','sentence','tell','does','too','old','boy','right','move','differ','mean','same','cause','turn','before','line','low','help','say','think','great','much','form','just','through','very','name']
@less_common_words = ['open','seem','together','next','white','children','begin','got','walk','example','ease','paper','often','always','music','those','both','mark','book','letter','until','mile','river','car','feet','care','second','group','carry','took','rain','eat','room','friend','began','idea','fish','mountain','north','once','base','hear','horse','cut','sure','watch','color','face','wood','main','enough','plain','girl','usual','young','ready','above','ever','red','list','though','feel','talk','bird','soon','body','dog','family','direct','pose','leave','song','measure','state','product','black','short','numeral','class','wind','question','happen','complete','ship','area','half','rock','order','fire','south','problem','piece','told','knew','pass','farm','top','whole','king','size','heard','best','hour','better','true','during','hundred','am','remember','step','early','hold','west','ground','interest','reach','fast','five','sing','listen','six','table','travel','less','morning']
@lesser_common_words = ['ten','simple','several','vowel','toward','war','lay','against','pattern','slow','center','love','person','money','serve','appear','road','map','science','rule','govern','pull','cold','notice','voice','fall','power','town','fine','certain','fly','unit','lead','cry','dark','machine','note','wait','plan','figure','star','box','noun','field','rest','correct','able','pound','done','beauty','drive','stood','contain','front','teach','week','final','gave','green','oh','quick','develop','sleep','warm','free','minute','strong','special','mind','behind','clear','tail','produce','fact','street','inch','lot','nothing','course','stay','wheel','full','force','blue','object','decide','surface','deep','moon','island','foot','yet','busy','test','record','boat','common','gold','possible','plane','age','dry','wonder','laugh','thousand','ago','ran','check','game','shape','yes','hot','miss','brought','heat','snow','bed','bring','sit','perhaps','fill','east','weight','language','among']

def tweet_reduce
  
  # take a tweet
  # pass through @most_common_words filter
  # if words left, pass through @common_words filter
  # if words left, pass through @less_common_words filter
  # if words left, pass through @lesser_common_words filter
  
  # once we have passed through all filters, we should be left with uncommon words, peoples names, and expressions
  
end

# count the words in the tweet
# which words repeat? don't repeat
def count_words(tweet)
  
end


def handle_tweet(tweet)
  
  puts "Rate Limit Error: " if tweet == "Easy there, Turbo. Too many requests recently. Enhance your calm."
  
  begin
    tweet = JSON.parse(tweet)
    pp tweet
  rescue JSON::ParserError => e
    puts "message: #{tweet.to_s}"
    puts "Don't parse non JSON. Wasted your time: #{e.inspect}"
  end
  
  return unless tweet['text']
  
  #pp tweet
  puts "====================================="
  puts 
  puts "@#{tweet['user']['screen_name']}: #{tweet['text']}"
  puts "Hashtags: #{tweet['entities']['hashtags'].inspect}"
  puts "====================================="
end

def stream_request
  puts "=================="
  puts "trying to grab info from stream"
  
  @request_url = 'http://stream.twitter.com/1/statuses/filter.json'
  #@request_url = 'http://stream.twitter.com/1/statuses/sample.json'
  http = EventMachine::HttpRequest.new(@request_url).get :query => {"track"=>"AOL,aol,Editions"}, :head => {'Authorization'=> ["newfront","Turtlepizza"] }
  
  buffer = ""
  
  http.stream do |chunk|
    
    buffer += chunk
    while line = buffer.slice!(/.+\r?\n/)
      handle_tweet(line)
    end
  end
  
  http.errback {
    puts "error on that one. try again"
  #  stream_request
  }
  
end


EM.run do
  puts "Twitter Streaming in 3 seconds"
  
  stream_request
  
end