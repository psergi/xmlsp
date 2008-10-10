require File.dirname(__FILE__) + '/../spec_helper.rb'

describe XMLSP::ElementListener do
  it "should include REXML::StreamListener" do
    XMLSP::ElementListener.included_modules.should include(REXML::StreamListener)
  end
  
  describe "attributes" do
    before(:each) do
      @element_listener = XMLSP::ElementListener.new('test')
    end
    it "should have a search_tag attribute" do
      @element_listener.should respond_to(:search_tag)
    end
    it "should have an on_element_parsed attribute" do
      @element_listener.should respond_to(:on_element_parsed)
    end
  end

  describe ".initialize" do
    before(:each) do
      @element_listener = XMLSP::ElementListener.new('test')
    end
    it "should set search tag to the given param" do
      @element_listener.search_tag.should == 'test'
    end
  end

  describe ".tag_start" do
    before(:each) do
      @element_listener = XMLSP::ElementListener.new('test')
    end
    it "should build a new element when search tag is passed" do
      tag = "test"
      attrs = {:enabled => true, :class => "right"}
      XMLSP::Element.should_receive(:new).with(tag, attrs)
      @element_listener.tag_start(tag, attrs)
    end
    it "should add a child element to the search tag element if called after search tag is opened and before search tag is closed" do
      tag = "test"
      attrs = {}
      element = XMLSP::Element.new('test')
      XMLSP::Element.should_receive(:new).twice.and_return(element)
      @element_listener.tag_start(tag, attrs)
      @element_listener.tag_start("tag", attrs)
      element.children.size.should == 1
    end
    it "should not create element if not within search tag" do
      tag = "jones"
      attrs = {}
      XMLSP::Element.should_not_receive(:new)
      @element_listener.tag_start(tag, attrs)
    end
  end

  describe ".tag_end" do
    before(:each) do
      @element_listener = XMLSP::ElementListener.new('test')
      @element_listener.on_element_parsed = mock(Proc)
      @element = mock(XMLSP::Element, :parent => nil)
      XMLSP::Element.stub!(:new).and_return(@element)
      @element_listener.tag_start("test", {})
    end
    it "should call on_element_parsed if search tag end is found" do
      tag = "test"
      @element_listener.on_element_parsed.should_receive(:call).with(@element)
      @element_listener.tag_end(tag)
    end
    it "should not call on_element_parsed if search tag end is found" do
      tag = "test"
      @element_listener.on_element_parsed = nil
      lambda { @element_listener.tag_end(tag) }.should_not raise_error
    end
  end

  describe ".text" do
    before(:each) do
      @element_listener = XMLSP::ElementListener.new('test')
      @element = mock(XMLSP::Element, :parent => nil)
      XMLSP::Element.stub!(:new).and_return(@element)
    end
    it "should set text on element" do
      @element_listener.tag_start("test", {})
      @element.should_receive(:text=).with("ok")
      @element_listener.text("ok")
    end
    it "should not set text if start tag not found yet" do
      lambda { @element_listener.text("ok") }.should_not raise_error
    end
  end

  describe ".cdata" do
    before(:each) do
      @element_listener = XMLSP::ElementListener.new('test')
      @element = mock(XMLSP::Element, :parent => nil)
      XMLSP::Element.stub!(:new).and_return(@element)
    end
    it "should set text on element" do
      @element_listener.tag_start("test", {})
      @element.should_receive(:text=).with("ok")
      @element_listener.cdata("ok")
    end
    it "should not set text if start tag not found yet" do
      lambda { @element_listener.cdata("ok") }.should_not raise_error
    end
  end
end

