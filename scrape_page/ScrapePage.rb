#!/usr/bin/ruby

# ScrapePage is a simple webpage scraper
# - Use this to scrape a webpage into a variable, or to output as a File
class ScrapePage

    def initialize(url='')

        # require a url
        unless url.empty?
            @@url = url
        else
            # Uncomment the Raise block to require a url
            #raise "You Can't Leave url blank. Try ScrapePage.new('http://www.domain.com',false)"
        end

    end
    
    # Grab the contents of the remote page
    def grab_page_contents(url='')

        # Test for url, is_file overrides
        unless url.empty?
            @@url = url
        end
        
        begin
            # Create a temporary File Object
            @@scraped_page = ''
            @@scraped_page << %x[curl -CO '#{@@url}']
            #puts "Got Page Contents: #{scraped_page.inspect}"
        
        rescue
            if defined? @@url
                puts "Page Doesn't seem to exist"
            else
                raise "You forgot to add a URL to the grab_page_contents block, or set initially" 
            end
        end
    end
    
    # output scraped page
    def scraped_page
       begin
           return @@scraped_page
        rescue
           raise "You need to run grab_page_contents before looking for a scraped page" 
        end
    end
    
    # output scraped_page to File
    def export_scraped_page(location='')
        
        unless location.empty?
            
            begin
                tmp = File.new(location,"w+")
                tmp << @@scraped_page
                tmp.close
            rescue
               raise "There seems to be an issue writing your file to #{location.to_s}. Check your permissions and try again." 
            end
        else
           raise 'You need to specifiy a location to save your scraped_page to. ex: /usr/local/tmp/page_name' 
        end
    end

end