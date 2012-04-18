module Notification
  
  def self.write(type, content, params={})
    raise "ParameterError" unless !type.nil? && !content.nil?
    notification = {};
    notification[:type] = type
    notification[:content] = content
    
    unless params.nil?
      # params can have url for now
      notification[:url] = params[:url]
    end
    notification
  end
  
end

#puts Notification.write("message", "Hello User")