module XMLSP
	class XMLStreamLoader
		attr_reader :file_directory, :file_list
		attr_accessor :on_file_opened
		
		def initialize(file_path)
		  raise 'file/directory #{file_path} does not exist' unless File.exists?(file_path)
		  @file_list = []
		  if(File.file?(file_path))
		    @file_list << File.basename(file_path)
		    @file_directory = File.dirname(file_path)
		  else
		    build_file_list()
		    @file_directory = file_path
		  end
		end
		
		def process_files(listener)
		  @file_list.each do |file|
		    if(!@on_file_opened.nil?)
		      @on_file_opened.call(file)
		    end
		    REXML::Document.parse_stream(File.new(File.join(@file_directory, file)), listener)
		  end
		end
		
		private
		def build()
		  Dir.foreach(@file_directory) do |file| 
		      @file_list.push(file)
		  end
		end
	end
end
