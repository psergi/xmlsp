require File.dirname(__FILE__) + '/../spec_helper.rb'

describe XMLSP::StreamParser do
  describe "attributes" do
    before(:each) do
      @stream_loader = XMLSP::StreamParser.new
    end
    it "should have file list" do
      @stream_loader.should respond_to(:file_list)
    end
    it "should have element_listener" do
      @stream_loader.should respond_to(:element_listener)
    end
    it "should have before_file_parsed" do
      @stream_loader.should respond_to(:before_file_parsed)
    end
    it "should have after_file_parsed" do
      @stream_loader.should respond_to(:after_file_parsed)
    end
  end

  describe ".initialize" do
    it "should default file list to []" do
      XMLSP::StreamParser.new.file_list.should == []
    end
    it "should take file option to initialize with a specific file" do
      File.stub!(:file?).and_return(true)
      stream_parser = XMLSP::StreamParser.new(:file => '/test')
      stream_parser.file_list.should == ['/test']
    end
    it "should take directory option to initialize with a directory" do
      File.stub!(:directory).and_return(true)
      feed_dir = File.expand_path(File.join(File.dirname(__FILE__), '/../fixtures/feeds'))
      stream_parser = XMLSP::StreamParser.new(:directory => feed_dir)
      stream_parser.file_list.should == ['feed_1.xml', 'feed_2.xml'].map { |f| File.join(feed_dir, f) }
    end
    it "should take  a pattern option with a directory to initialize with files matching the pattern in the directory" do
      feed_dir = File.expand_path(File.join(File.dirname(__FILE__), '/../fixtures/feeds'))
      stream_parser = XMLSP::StreamParser.new(:directory => feed_dir, :pattern => '\.(xml|rss)$')
      stream_parser.file_list.sort.should == ['feed_1.xml', 'feed_2.xml', 'feed_3.rss'].map { |f| File.join(feed_dir, f) }
    end
  end

  describe ".parse" do
    before(:each) do
      @feed_dir = File.expand_path(File.join(File.dirname(__FILE__), '/../fixtures/feeds'))
      @stream_parser = XMLSP::StreamParser.new(:directory => @feed_dir)
      REXML::Document.stub!(:parse_stream)
    end
    it "should parse file with the set listener" do 
      File.stub!(:file?).and_return(true)
      filename = '/test.xml'
      file = mock(File)
      File.stub!(:new).with(filename).and_return(file)
      stream_parser = XMLSP::StreamParser.new(:file => filename)
      listener = mock(Proc)
      stream_parser.element_listener = listener
      REXML::Document.should_receive(:parse_stream).with(file, listener)
      stream_parser.parse
    end
    it "should parse each file in the file list" do
      REXML::Document.should_receive(:parse_stream).exactly(@stream_parser.file_list.size).times
      @stream_parser.parse
    end
    it "should call before_file_parsed before parsing file" do
      callback = mock(Proc)
      @stream_parser.before_file_parsed = callback
      @stream_parser.before_file_parsed.should_receive(:call).exactly(@stream_parser.file_list.size).times
      @stream_parser.parse
    end
    it "should call after_file_parsed after parsing file" do
      callback = mock(Proc)
      @stream_parser.after_file_parsed = callback
      @stream_parser.after_file_parsed.should_receive(:call).exactly(@stream_parser.file_list.size).times
      @stream_parser.parse
    end
  end
end

