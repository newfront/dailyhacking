#!/usr/bin/env ruby

$: << File.join(File.dirname(__FILE__), "")
$: << $APP_ROOT = File.expand_path(File.dirname(__FILE__))

# grab dependencies
requires = ['em-websocket','cgi','em-http-request','sinatra/base','haml','thin','logger','hashie','mechanize','socket','pp','json','yaml','mongoid']
requires.each {|dependency| require dependency}

# include our parser lib and connection lib
require 'lib/parser'
require 'lib/word_parser'
require 'lib/connection'

# Grab Model Files
require 'model/tweet'

@params = ARGV # grab username and password (twitter username/password) from command line

$user = {
  :username => @params[0],
  :password => @params[1],
  :google_dev_key => "ABQIAAAAqj2FkdNbZi_ZKy1fY_HdjxQsPFBHlSdy9MSZLoC4ErdaOPqPGhSsI3FcfI7uPySPy7zgD5eo88rAWw",
  :google_dev_url => "http://gravitateapp.com"
}

$db = {
  :name => "tweetdata"
}

##############################
# CONFIG
##############################

$search_words = ['AOL','Huffington Post','Tech Crunch','Joystiq']
#$most_common_words = ['the','because','of','to','and','a','in','is','it','you','that','he','was','for','on','are','with','as','I','his','they','be','at','one','have','this','from','or','had','by','not','but','some','what','there','we','can','out','other','were','all','your','when','up','use','word','how','said','an','each','she','which','do','their','time','if','will','way','about','many','then','them','would','write','like','so','these','her','long','make','thing','see','him','two','has','look','more','day','could','go','come','did','my','sound','no','most','number','who','over','water','than','call','first','may','down','side','been','now','find','any','new','part','take','get','place','made','live','where','after','back','little','only','round','man','year','came','show','every','good','me','give','our','under']
#$common_words = ['stop','few','life','real','night','close','press','while','run','late','left','draw','sea','far','saw','story','might','start','hard','slice','cross','tree','city','between','door','last','never','eye','keep','let','thought','four','sun','food','cover','plant','learn','still','study','grow','school','answer','found','country','should','page','own','stand','head','father','earth','self','build','near','world','mother','point','animal','again','us','try','picture','house','need','off','kind','light','went','change','men','ask','why','act','such','high','big','must','here','land','even','add','spell','large','port','hand','read','home','put','end','small','play','also','well','air','want','three','set','sentence','tell','does','too','old','boy','right','move','differ','mean','same','cause','turn','before','line','low','help','say','think','great','much','form','just','through','very','name','liked','hello']
#$less_common_words = ['open','seem','together','next','white','children','begin','got','walk','example','ease','paper','often','always','music','those','both','mark','book','letter','until','mile','river','car','feet','care','second','group','carry','took','rain','eat','room','friend','began','idea','fish','mountain','north','once','base','hear','horse','cut','sure','watch','color','face','wood','main','enough','plain','girl','usual','young','ready','above','ever','red','list','though','feel','talk','bird','soon','body','dog','family','direct','pose','leave','song','measure','state','product','black','short','numeral','class','wind','question','happen','complete','ship','area','half','rock','order','fire','south','problem','piece','told','knew','pass','farm','top','whole','king','size','heard','best','hour','better','true','during','hundred','am','remember','step','early','hold','west','ground','interest','reach','fast','five','sing','listen','six','table','travel','less','morning']
#$lesser_common_words = ['ten','simple','several','vowel','toward','war','lay','against','pattern','slow','center','love','person','money','serve','appear','road','map','science','rule','govern','pull','cold','notice','voice','fall','power','town','fine','certain','fly','unit','lead','cry','dark','machine','note','wait','plan','figure','star','box','noun','field','rest','correct','able','pound','done','beauty','drive','stood','contain','front','teach','week','final','gave','green','oh','quick','develop','sleep','warm','free','minute','strong','special','mind','behind','clear','tail','produce','fact','street','inch','lot','nothing','course','stay','wheel','full','force','blue','object','decide','surface','deep','moon','island','foot','yet','busy','test','record','boat','common','gold','possible','plane','age','dry','wonder','laugh','thousand','ago','ran','check','game','shape','yes','hot','brought','heat','snow','bed','bring','sit','perhaps','fill','east','weight','language','among']

#common = "via,CC,'tis,'twas,a,able,about,across,after,ain't,all,almost,also,am,among,an,and,any,are,aren't,as,at,be,because,been,but,by,can,can't,cannot,could,could've,couldn't,dear,did,didn't,do,does,doesn't,don't,either,else,ever,every,for,from,get,got,had,has,hasn't,have,he,he'd,he'll,he's,her,hers,him,his,how,how'd,how'll,how's,however,i,i'd,i'll,i'm,i've,if,in,into,is,isn't,it,it's,its,just,least,let,like,likely,may,me,might,might've,mightn't,most,must,must've,mustn't,my,neither,no,nor,not,of,off,often,on,only,or,other,our,own,rather,said,say,says,shan't,she,she'd,she'll,she's,should,should've,shouldn't,since,so,some,than,that,that'll,that's,the,their,them,then,there,there's,these,they,they'd,they'll,they're,they've,this,tis,to,too,twas,us,wants,was,wasn't,we,we'd,we'll,we're,were,weren't,what,what'd,what's,when,when,when'd,when'll,when's,where,where'd,where'll,where's,which,while,who,who'd,who'll,who's,whom,why,why'd,why'll,why's,will,with,won't,would,would've,wouldn't,yet,you,you'd,you'll,you're,you've,your"
#$common_words = common.split(/\,/)
#$connecting_words = ["to","from","last","tell","told","of","on","during","-"]
#$words = {}
#$users = {}
#$urls = {}

##############################

# open up stream to Twitter (pipe)
WAIT_TIME_DEAFULT = 90
@wait_time = WAIT_TIME_DEAFULT # initially start at 4 minutes

def stream_request
  puts "==================================\n\n"
  puts "Start Grabing Info from the Stream"
  
  @request_url = 'http://stream.twitter.com/1/statuses/filter.json'
  #@request_url = 'http://stream.twitter.com/1/statuses/sample.json'
  http = EventMachine::HttpRequest.new(@request_url).post :head => {'Authorization'=> [$user[:username],$user[:password]],'Content-Type'=>"application/x-www-form-urlencoded"}, :body => "track=AOL,Editions by AOL,america online,aim chat,webaim,joystiq"
  #puts http.inspect
  buffer = ""
  
  # Grab initial headers
  http.headers {
    #pp http.response_header.status
    if http.response_header.status.to_i == 401
      raise "Error. Authentication Required. Please add your username and password to the command line"
    end
  }
  
  # Grab stream as it becomes available
  http.stream do |chunk|
    buffer += chunk
    while line = buffer.slice!(/.+\r?\n/)
      Parser::grab_tweet(line)
    end
    
  end
  
  # Stream is now complete, issue reconnection
  http.callback {
    pp http.response_header.status
    pp http.response
    
    puts "connection closed by Twitter. Reconnect"
    
    if http.response_header.status == 420
      @wait_time += 60
    elsif http.response_header.status == 200
      @wait_time = 20
    else
      @wait_time = WAIT_TIME_DEAFULT
    end
    
    puts "Next run in #{@wait_time.to_s}"
    EventMachine::Timer.new(@wait_time) do
      stream_request
    end
    
  }
  
  # Error connecting, try again
  http.errback {
    puts "error on that one. try again"
    EventMachine::Timer.new(20) do
      stream_request
    end
  }
  
end


EM.run do
  puts "Twitter Streaming in 3 seconds"
  Connection::MongoDB::connect($db[:name])
  
  stream_request
  
end

puts "EventMachine has stopped. Live Stream is no more"