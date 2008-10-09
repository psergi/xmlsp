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
      @element_listner.search_tag.should == 'test'
    end
      
end

