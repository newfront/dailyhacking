#!/usr/bin/env ruby

class Formatter
    def output_report(title, text)
        raise 'Abstract Method called'
    end
end

class HTMLFormatter < Formatter
    def output_report(title, text)
        puts('<html>')
        puts('  <head>')
        puts("      <title>#{title}</title>")
        puts('  </head>')
        puts('  <body>')
        text.each do |line|
            puts("  <p>#{line}</p>")
        end
        puts('  </body>')
        puts('</html>')
    end
end

class PlainTextFormatter < Formatter
    def output_report(title, text)
        puts("**** #{title} ****");
        text.each do |line|
            puts(line)
        end
    end
end

class Report
    attr_reader :title, :text
    attr_writer :formatter
    
    def initialize(formatter)
        @title = 'Monthly Report'
        @text = ["Things are going", "really well."]
        @formatter = formatter
    end
    
    def output_report
        @formatter.output_report(@title, @text)
    end
end

r = Report.new(HTMLFormatter.new)
r.output_report
r.formatter = PlainTextFormatter.new
r.output_report