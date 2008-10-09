module XMLSP
	class StreamLoader
		attr_reader :file_directory, :file_list
		attr_accessor :on_file_opened
		
		def initialize(file_path, pattern = '.xml$')
		  raise "file/directory '#{file_path}' does not exist" unless File.exists?(file_path)
		  @file_list = []
		  if(File.file?(file_path))
		    @file_list << File.basename(file_path)
		    @file_directory = File.dirname(file_path)
		  else
		    @pattern = pattern
		    @file_directory = file_path
		    build_file_list()
		  end
		end
		
		def process_files(listener)
		  @file_list.each do |file|
		  	file_path = File.join(@file_directory, file)
		  	@on_file_opened.call(file_path) unless @on_file_opened.nil?
		    REXML::Document.parse_stream(File.new(file_path), listener)
		  end
		end
		
		private
		def build_file_list()
		  Dir.foreach(@file_directory) do |file|
		      @file_list << file if(file.match(@pattern))
		  end
		end
	end
end
