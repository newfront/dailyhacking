module Helpers
  
  module Error
    def self.to_error(params = {})
      error = Hashie::Mash.new
      params.each{|k,v| error[k] = v}
      return error
    end
  end
  
  module Request
    include Enumerable
    # OpenAim requires all parameters to be normalized and escaped
    # prior to sending each request
    def self.normalize(params={})
      return params.sort
    end
    
    # Usage to_qs
    #params = {'x'=>"joe",'a'=>"jordan",'p'=>'something'}
    def self.to_qs(params={})
      tmp = normalize(params)
      qs = tmp.each.map{|array| "#{CGI.escape(array[0].to_s)}=#{CGI.escape(array[1].to_s)}"}
      return qs.join("&")
    end
    
    def self.builder(url,query={},signed=true)
      
      case signed.to_s
        when "true"
          pieces = OpenAim::Helpers::Authenticate.sign(url,query)
          url = pieces["url"] +"?"+pieces["qs"]+"&sig_sha256="+pieces["sig_sha256"]
        when "false"
          qs = self.to_qs(query)
          url = url+"?"+qs
      end
      return url.to_s
    end
  end
  
  module Authenticate
    
    def self.sign(url,query={},type="GET",key=nil)
      puts "IN AUTHENTICATE"
      #TODO return error if url or query are absent
      return Helpers::Error.to_error({"code"=>460,"status"=>"Missing url parameter"}) unless !url.empty?
      return Helpers::Error.to_error({"code"=>460,"status"=>"Missing query hash"}) unless !query.empty?
      
      key = self.get_session_key unless !key.nil?
      request_query = Helpers::Request.to_qs(query).to_s
      #$log.debug "normalized query: #{request_query}"
      request_signature = "GET&"
      request_signature << CGI.escape(url)
      request_signature << "&"
      request_signature << CGI.escape(request_query)

      signature = Base64.encode64(HMAC::SHA256.digest(key,request_signature)).strip
      #$log.debug "Signature: #{signature}"
      
      return {"url" => url, "qs" => request_query, "sig_sha256" => signature}
      
    end

    def self.get_session_key(secret=nil,password=nil)
      session_secret = secret.nil? ? $client.session_secret : secret
      customer_password = password.nil? ? $config_aim.credentials.password : password
      return Base64.encode64(OpenSSL::HMAC.digest('sha256',customer_password.to_s,session_secret.to_s)).strip
    end
    
    def self.calculate_nonce salt
      puts "calculate_nonce: #{salt.inspect}"
      begin
        return Digest::MD5.hexdigest(salt)
      rescue NameError => e
        return e
      rescue TypeError => e
        return e
      end
    end
  
  end
  
end