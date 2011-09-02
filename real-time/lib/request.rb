class Request
  attr_accessor :callback, :request_url, :request_method, :query, :timeout, :head, :status, :response, :error

  def initialize(url,params={
    :type=>"get",
    :query=>{},
    :timeout => 10,
    :head => {}
    },&block)
    self.callback = params[:callback] unless params[:callback].nil?
    self.request_url = url
    self.request_method = params[:type].nil? ? "get" : params[:type].downcase
    self.query = params[:query].nil? ? nil : params[:query]
    self.timeout = params[:timeout].nil? ? 10 : params[:timeout]
    self.head = params[:head].nil? ? nil : params[:head]
    self.status = "initalized"
    
    self.create do |response|
      block.call(response) if block_given?
    end
  end

  def create &block
    #p self.query
    #p self.timeout
    #p self.head
    #p self.request_url
    case self.request_method.to_s.downcase
      when "get"
        http = EventMachine::HttpRequest.new(self.request_url).get :query => self.query , :timeout => self.timeout, :head => self.head
      when "post"
        http = EventMachine::HttpRequest.new(self.request_url).post :query => self.query , :timeout => self.timeout, :head => self.head
    else
      return nil
    end

    http.callback {
      response = OpenAim::Parser::Response.to_hashie(http)
      $requests += 1
      $log.info "Total Requests: #{$requests.to_s}"
      block.call(response) if block_given?
    }
    http.error {
      response = OpenAim::Parser::Response.to_hashie(http)
      block.call(response) if block_given?
    }
  end
end