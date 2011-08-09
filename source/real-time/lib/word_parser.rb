require 'hashie'
# word parser, weighted

common = "via,CC,'tis,'twas,a,able,about,across,after,ain't,all,almost,also,am,among,an,and,any,are,aren't,as,at,be,because,been,but,by,can,can't,cannot,could,could've,couldn't,dear,did,didn't,do,does,doesn't,don't,either,else,ever,every,for,from,get,got,had,has,hasn't,have,he,he'd,he'll,he's,her,hers,him,his,how,how'd,how'll,how's,however,i,i'd,i'll,i'm,i've,if,in,into,is,isn't,it,it's,its,just,least,let,like,likely,may,me,might,might've,mightn't,most,must,must've,mustn't,my,neither,no,nor,not,of,off,often,on,only,or,other,our,own,rather,said,say,says,shan't,she,she'd,she'll,she's,should,should've,shouldn't,since,so,some,than,that,that'll,that's,the,their,them,then,there,there's,these,they,they'd,they'll,they're,they've,this,tis,to,too,twas,us,wants,was,wasn't,we,we'd,we'll,we're,were,weren't,what,what'd,what's,when,when,when'd,when'll,when's,where,where'd,where'll,where's,which,while,who,who'd,who'll,who's,whom,why,why'd,why'll,why's,will,with,won't,would,would've,wouldn't,yet,you,you'd,you'll,you're,you've,your"
$common_words = common.split(/\,/)

$connecting_words = ["to","from","last","tell","told","of","on","during","-","&","and"]
$punctuation = [".","&","!","=","|","?","-"]
$possesive_words = ["my","mine","his","hers","your"]
$twitter_specific = ["via","RT","CC"]

$search_words = ['AOL','Huffington Post','Tech Crunch','Joystiq']
#$most_common_words = ['the','because','of','to','and','a','in','is','it','you','that','he','was','for','on','are','with','as','I','his','they','be','at','one','have','this','from','or','had','by','not','but','some','what','there','we','can','out','other','were','all','your','when','up','use','word','how','said','an','each','she','which','do','their','time','if','will','way','about','many','then','them','would','write','like','so','these','her','long','make','thing','see','him','two','has','look','more','day','could','go','come','did','my','sound','no','most','number','who','over','water','than','call','first','may','down','side','been','now','find','any','new','part','take','get','place','made','live','where','after','back','little','only','round','man','year','came','show','every','good','me','give','our','under']
#$common_words = ['stop','few','life','real','night','close','press','while','run','late','left','draw','sea','far','saw','story','might','start','hard','slice','cross','tree','city','between','door','last','never','eye','keep','let','thought','four','sun','food','cover','plant','learn','still','study','grow','school','answer','found','country','should','page','own','stand','head','father','earth','self','build','near','world','mother','point','animal','again','us','try','picture','house','need','off','kind','light','went','change','men','ask','why','act','such','high','big','must','here','land','even','add','spell','large','port','hand','read','home','put','end','small','play','also','well','air','want','three','set','sentence','tell','does','too','old','boy','right','move','differ','mean','same','cause','turn','before','line','low','help','say','think','great','much','form','just','through','very','name','liked','hello']
$less_common_words = ['open','seem','together','next','white','children','begin','got','walk','example','ease','paper','often','always','music','those','both','mark','book','letter','until','mile','river','car','feet','care','second','group','carry','took','rain','eat','room','friend','began','idea','fish','mountain','north','once','base','hear','horse','cut','sure','watch','color','face','wood','main','enough','plain','girl','usual','young','ready','above','ever','red','list','though','feel','talk','bird','soon','body','dog','family','direct','pose','leave','song','measure','state','product','black','short','numeral','class','wind','question','happen','complete','ship','area','half','rock','order','fire','south','problem','piece','told','knew','pass','farm','top','whole','king','size','heard','best','hour','better','true','during','hundred','am','remember','step','early','hold','west','ground','interest','reach','fast','five','sing','listen','six','table','travel','less','morning']
$lesser_common_words = ['ten','simple','several','vowel','toward','war','lay','against','pattern','slow','center','love','person','money','serve','appear','road','map','science','rule','govern','pull','cold','notice','voice','fall','power','town','fine','certain','fly','unit','lead','cry','dark','machine','note','wait','plan','figure','star','box','noun','field','rest','correct','able','pound','done','beauty','drive','stood','contain','front','teach','week','final','gave','green','oh','quick','develop','sleep','warm','free','minute','strong','special','mind','behind','clear','tail','produce','fact','street','inch','lot','nothing','course','stay','wheel','full','force','blue','object','decide','surface','deep','moon','island','foot','yet','busy','test','record','boat','common','gold','possible','plane','age','dry','wonder','laugh','thousand','ago','ran','check','game','shape','yes','hot','brought','heat','snow','bed','bring','sit','perhaps','fill','east','weight','language','among']

class WordParser
  include Enumerable
  
  def initialize(params={})
    
    @sentance = params[:tweet]
    @word = []
    @count = 0
    @local_important = []
    @results = {}
    self.process_sentance(@sentance)
    
  end

  # recursively test each word in the tweet
  # apply weights to each value
  def parse_words(list,check_next=false)
    
    if list.size == 1
      puts "nothing left in list: #{list[0].inspect}"
      result = test_word(list[0],check_next)
      @word << result
      
      if !result.url && result.twitter_handle.empty? && !result.punctuation
        @results.store(result.word,result.weight)
      end
      tmp = @count
      @count += 1
      return @word
    else
      result = test_word(list[0],check_next)
      #puts "result: #{result.inspect}"
      @word << result
      
      puts result.url.to_s
      
      if !result.url && result.twitter_handle.empty? && !result.punctuation
        @results.store(result.word,result.weight)
      end
      parse_words(list[0+1,list.size],true)
    end
  end
  
  @starting_weight = 0
  
  def test_word(word,important=false,params={})
    weights = 0
    weights += @starting_weight if important
    next_word_check = false
    possesive = false
    connecting = false
    twitter_handle = ""
    common = false
    punctuation = false
    url = false
    
    @starting_weight = 0 unless important
    
    word = word.gsub(/[?!]*/,'')
  
    if is_capitalized? word
      weights += 1
    end
  
    if is_connecting_word? word
      # if it is connecting, next word may be valuable
      #puts "word is a connecting word: #{word}"
      next_word_check = true
      @starting_weight += 1
      connecting = true
    end
  
    if is_camel_case? word
      weights += 1
    end
  
    if is_possesive? word
      #puts "word is possesive. next object may be important"
      next_word_check = true
      @starting_weight += 1
      possesive = true
    end
  
    if is_twitter_handle? word
      #puts "Twitter Handle: #{word}"
      twitter_handle = word
      weights = 0
    end
  
    if is_url? word
      weights = 0
      url = true
    end
    
    if is_locally_important? word
      weights += 2
    end
  
    unless is_common? word
      weights += 1
    else
      common = true
      weights = 0
    end
  
    if is_punctuation? word
      weights = 0
      punctuation = true
    end
    
    if is_twitter_specific? word
      puts "is twitter specific: #{word}"
      weights = 0
      next_word_check = true
      @starting_weight += 1
    end
    
    if is_search_word? word
      weights = 0
      next_word_check = true
      @starting_weight += 1
    end
    
    weights += 1 if is_lesser_common? word
    
    weights += 2 if is_least_common? word
    
    
    tmp = Hashie::Mash.new
    tmp.word = word
    tmp.weight = weights
    tmp.check_next = next_word_check
    tmp.possesive = possesive
    tmp.connecting = connecting
    tmp.twitter_handle = twitter_handle
    tmp.url = url
    tmp.punctuation = punctuation
  
    return tmp 
  end
  
  def is_twitter_specific? word
    return true if $twitter_specific.include? word
    return false
  end

  def is_twitter_handle? word
    return true if word.match(/(@[A-Za-z0-9_])/)
    return false
  end

  def is_camel_case?(word)
    return true if word[0,1] == word[0,1].upcase
    return false
  end
  
  def is_search_word? word
    return true if $search_words.include? word
    return true if $search_words.include? word.downcase
    return false
  end

  # check if the word is capitalized
  def is_capitalized?(word)
    return true if word == word.upcase
    return false
  end

  def is_url? word
    return true if word.match(/http:.*/i)
    return false
  end
  
  # check if the word is common to english language
  def is_common?(word)
    return true if $common_words.include? word.downcase
    return false
  end
  
  def is_lesser_common? word
    return true if $less_common_words.include? word
    return false
  end
  
  def is_least_common? word
    return true if $lesser_common_words.include? word
    return false
  end
  
  def is_punctuation? word
    return true if $punctuation.include? word
    return false
  end
  
  def is_connecting_word? word
    return true if $connecting_words.include? word.downcase
    return false
  end
  
  # check if someone has ownership
  def is_possesive? word
    return true if $possesive_words.include? word.downcase
    return false
  end
  
  def is_locally_important? word
    return true if @local_important.include? word.downcase
    return false
  end
  
  # process the sentance, pull out words in quotes
  def process_sentance(blob)
    # strip out enclosures
    blob = blob.gsub(/\\/,'')
    # test for quotes
    # if quotes, these words are important (flag them)
    test = blob.match(/["'](.*)['"]/)
    if test && test.size > 1
      @words = test[1..test.size].join(" ")
      #test.each{|word|
      #  @words << word
      #}
      #blob = blob.gsub(@words,'')
      blob = blob.gsub(/(["'])/,'')
    end
    unless @words.nil?
      # break up and add to @local_important
      tmp = @words.split(" ")
      tmp.each{|word|
        @local_important << word.downcase unless @local_important.include? word
      }
    end
    #puts blob
    the_pieces = blob.split(" ")
    parse_words(the_pieces)
    
    # try to sort words
    words = grab_important_words
    puts words.inspect
    
    puts "Derived Tags: #{words.join(' ')}"
    
  end
  
  def get_result
    return @word
  end
  
  def sort_words
    tmp = @results.to_a.sort_by {|a,b| b}
    return tmp.reverse
  end
  
  def grab_important_words
    @importants = []
    tmp = sort_words
    greatest = tmp[0][1]
    least = tmp[tmp.size-1][1]
    
    puts "Highest Weight: #{greatest.to_s} | least: #{least.to_s}"
    
    tmp.each {|arr|
      # each is an sub-array
      info = []
      a,b = arr[0],arr[1]
      puts "The word #{a.to_s} is weighted at #{b.to_s}"
      if b > greatest / 2
        @importants << a
      end
    }
    return @importants
  end
  
end