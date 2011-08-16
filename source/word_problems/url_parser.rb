#!/usr/bin/env ruby

require 'cgi'
require 'hashie'

=begin
http://www.nytimes.com/2011/08/11/business/daily-stock-market-activity.html
http://www.nytimes.com/2011/08/11/business/daily-stock-market-activity.html?hp
http://www.wired.com/gaming/gamingreviews/multimedia/2002/07/53929
http://www.wired.com/gaming/gamingreviews/multimedia/2002/07/53929?slide=2&slideView=2
http://www.huffingtonpost.com/2011/08/11/past-presidential-vacations_n_872469.html#s288546&title=Abraham_Lincoln
http://www.huffingtonpost.com/2011/08/11/past-presidential-vacations_n_872469.html#s288534&title=John_F_Kennedy
http://www.huffingtonpost.com/2011/08/11/past-presidential-vacations_n_872469.html#s288528&title=Ronald_Reagan
http://www.sfgate.com/cgi-bin/article.cgi?f=/c/a/2011/08/15/BAQS1KMS3N.DTL&tsp=1
http://www.sfgate.com/cgi-bin/article.cgi?f=/c/a/2011/07/29/BAUJ1KGQFH.DTL
=end

@urls = []

# grab the pieces of the url

def parse_url (url)
  url = CGI.unescape(url)
  
  @data = Hashie::Mash.new
  # is it qs or hash
  separator = qs_or_hash? url
  #puts separator
  
  @data.separator = separator
  
  # grab sections
  sections = url.gsub(/^([A-Za-z:]*)+(\/\/)/,'').strip
  sections = sections.split("/")
  #puts sections.inspect
  
  @data.sections = sections
  
  # grab full url upto hash or querystring
  tmp = url.rindex(/\?|\#/)
  unless tmp.nil?
    tmp_url = url[0,tmp]
    @data.base_url = tmp_url
  else
    @data.base_url = url
  end
  
  # break down url
  chunks = nil
  unless sections.size == 1
    if !sections.last.match(/\?|\#/).nil?
      chunks = sections.last.split(/\?|\#/)
      #puts chunks.inspect
      @data.chunks = chunks
    elsif !url.match(/\?|\#/).nil?
      tmp = url.rindex(/\?|\#/)
      unless tmp.nil?
        tmp_url = url[(tmp+1),url.length]
        chunks = url.split(/\?|\#/)
      end
    end
  end
  
  # if array length is not = 1
  unless chunks.nil? || chunks[1].nil?
    res = break_down_qs(chunks[1],@data.separator)
    #puts res.inspect
    @data.params = res
  end
  
  @urls << [url,@data]
  return @data
  
end

# check for presence of hash or qs in url
def qs_or_hash? url
  hash = false
  qs = false
  hash = true if url.match(/\#/)
  qs = true if url.match(/\?/)
  return "both" if hash && qs
  return "hash" if hash && !qs
  return "qs" if !hash && qs
  return "none" if !hash && !qs
end

# break apart query string
# return array
def break_down_qs(qs,separator)
  response = Hashie::Mash.new
  
  # if & is a separator
  if qs.match(/\&/)
    pieces = qs.split(/\&/).to_a
    pieces.each_with_index{|data,i|
      if data.match(/\=/)
        a,b = data.split(/\=/)
        response[a] = b
      else
        response[separator] = data
      end
    }
  else
    response[separator] = qs
  end
  #puts response.inspect
  return response
end

# weight the full url for matches
def return_match_strength(data,dataset)
  # test url against urls in list
  # value for value, what matches, what doesn't match
  # return match factor
  
  #["http://www.sfgate.com/cgi-bin/article.cgi?f=/c/a/2011/08/15/BAQS1KMS3N.DTL&tsp=1", 
  #<#Hashie::Mash params=<#Hashie::Mash f="/c/a/2011/08/15/BAQS1KMS3N.DTL" tsp="1"> sections=["www.sfgate.com", "cgi-bin", "article.cgi?f=", "c", "a", "2011", "08", "15", "BAQS1KMS3N.DTL&tsp=1"] separator="qs">]
  @tests = []
  #puts data[1].inspect
  dataset.each_with_index{|test,i|
    @weight = 0
    #puts test[1].inspect
    weigh_base_url(data[1].base_url,test[1].base_url) unless data[1].base_url.nil? && test[1].base_url.nil?
    #puts @weight.to_s
    #puts "LOOP: #{i.to_s}"
    #puts test[1].separator
    #puts data[1].separator
    #puts data[1].has_key?("params")
    #puts test[1].has_key?("params")
    unless test[1].separator == "none" && data[1].separator == "none"
      #puts "test params"
      weigh_params(data[1].params,test[1].params) unless !data[1].has_key?("params") && !test[1].has_key?("params")
    end
    #puts @weight.to_s
    @tests << [test[0],@weight] unless @weight < 2
  }
  return @tests
end

# weight a (test params) against b (dataset params)
def weigh_params(a,b)
  return unless !a.nil? && !b.nil?
  b.each{|k,v|
    #puts "#{k.to_s}:#{v.to_s}"
    if a.has_key? k
      @weight += 1
      #puts "share params key: #{k.to_s}"
      #puts "#{k.to_s}:#{v.to_s}"
      #puts "test params value : #{a[k]}"
      if a[k] == b[k]
        #puts "match on #{k.to_s} = #{v.to_s}"
        @weight += 3
      end
    end
  }
end

def weigh_base_url(a,b)
  #puts "TEST URL: #{a} vs #{b}"
  unless a != b
    #puts "base url is similar"
    @weight += 2
  end 
end

test_urls = [
  "http://www.nytimes.com/2011/08/11/business/daily-stock-market-activity.html",
  "http://www.nytimes.com/2011/08/11/business/daily-stock-market-activity.html?hp",
  "http://www.wired.com/gaming/gamingreviews/multimedia/2002/07/53929",
  "http://www.wired.com/gaming/gamingreviews/multimedia/2002/07/53929?slide=2&slideView=2",
  "http://www.huffingtonpost.com/2011/08/11/past-presidential-vacations_n_872469.html#s288546&title=Abraham_Lincoln",
  "http://www.huffingtonpost.com/2011/08/11/past-presidential-vacations_n_872469.html#s288534&title=John_F_Kennedy",
  "http://www.huffingtonpost.com/2011/08/11/past-presidential-vacations_n_872469.html#s288528&title=Ronald_Reagan&val=90",
  "http://www.sfgate.com/cgi-bin/article.cgi?f=/c/a/2011/08/15/BAQS1KMS3N.DTL&tsp=1",
  "http://www.sfgate.com/cgi-bin/article.cgi?f=%2Fc%2Fa%2F2011%2F07%2F29%2FBAUJ1KGQFH.DTL"
  ]
test_urls.each{|url|
  parse_url(url)
}

@urls.each{|data|
  a,b = data[0],data[1]
  #puts "\n************************"
  #puts "MAIN URL: #{a.to_s}"
  #puts "PARSED DATA: #{b.inspect}"
  #puts "************************\n"
}

@urls.each{|data|
  puts "*****************************"
  puts "TEST FOR: #{data[0]}\n"
  match_weight = return_match_strength(data,@urls)
  match_weight.each{|d,weight|
    puts "url: #{d.to_s} matches with weight of #{weight.to_s}"
  }
  puts "*****************************"
}