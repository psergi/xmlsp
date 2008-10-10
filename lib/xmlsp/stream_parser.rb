module XMLSP
  class StreamParser
    attr_accessor :file_list, :element_listener, :before_file_parsed, :after_file_parsed
    
    # options
    # :file => filename
    # :directory => directory of files
    # :pattern => regex to match files when given a directory
    # 
    # note: only file or directory can be used at once, uses file if both are given
    #
    def initialize(options = {})
      @file_list = []
      if(options[:file] && File.file?(options[:file]))
        @file_list << File.expand_path(options[:file])
      elsif(options[:directory] && File.directory?(options[:directory]))
        pattern = options[:pattern] || /\.xml$/
        build_file_list(options[:directory], pattern)
      end
    end
    
    def parse
      @file_list.each do |file|
        @before_file_parsed.call(file) unless @before_file_parsed.nil?
        REXML::Document.parse_stream(File.new(file), @element_listener)
        @after_file_parsed.call(file) unless @after_file_parsed.nil?
      end
    end
    
    private

    def build_file_list(directory, pattern)
      Dir.foreach(directory) do |file|
          file_path = File.join(directory, file)
          @file_list << file_path if(file.match(pattern))
      end
    end
  end
end
