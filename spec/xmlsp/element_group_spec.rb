require File.dirname(__FILE__) + '/../spec_helper.rb'

describe XMLSP::ElementGroup do
  it "should include Enumerable" do
    XMLSP::ElementGroup.included_modules.should include(Enumerable)
  end

  describe "attributes" do
    before(:each) do
      @element_group = XMLSP::ElementGroup.new("group")
    end
    it "should have elements attribute" do
      @element_group.should respond_to(:elements)
    end
    it "should have tag attribute" do
      @element_group.should respond_to(:tag)
    end
    it "should have parent attribute" do
      @element_group.should respond_to(:parent)
    end
  end

  describe ".initialize" do
    before(:each) do
      @element_group = XMLSP::ElementGroup.new("group")
    end
    it "should create an element group with the tag name given" do
      @element_group.tag.should == "group"
    end
    it "should have a default elements of []" do
      @element_group.elements.should == []
    end
  end

  describe ".add_element" do
    before(:each) do
      @element_group = XMLSP::ElementGroup.new("group")
      @element = XMLSP::Element.new("group", "ok")
    end
    it "should add the element to the elements array" do
      @element_group.add_element(@element)
      @element_group.elements.should == [@element]
    end
    it "should not add the element if not given an element" do
      @element_group.add_element("test")
      @element_group.elements.should == []
    end
    it "should be aliased as <<" do
      @element_group << @element
      @element_group.elements.should == [@element]
    end
  end
  
  describe ".each" do 
    before(:each) do
      @element_group = XMLSP::ElementGroup.new("group")
      @element = XMLSP::Element.new("group", "ok")
      @element2 = XMLSP::Element.new("group", "ok2")
      @element_group.add_element(@element)
      @element_group.add_element(@element2)
    end
    it "should call the passed block on each element" do
      @element.should_receive(:do_this)
      @element2.should_receive(:do_this)
      @element_group.each { |e| e.do_this }
    end
  end 

  describe ".[]" do
    before(:each) do
      @element_group = XMLSP::ElementGroup.new("group")
      @element = XMLSP::Element.new("group", "ok")
      @element_group.add_element(@element)
    end
    it "should return element at index" do
      @element_group[0].should == @element
    end
    it "should return nil if no element at index" do
      @element_group[1].should be_nil
    end
  end

  describe ".to_hash" do
    before(:each) do
      @element_group = XMLSP::ElementGroup.new("group")
      @element = XMLSP::Element.new("group", "ok")
      @element2 = XMLSP::Element.new("group")
      @element3 = XMLSP::Element.new("test", "not ok")
      @element2.add_element(@element3)
      @element_group.add_element(@element)
      @element_group.add_element(@element2)
    end
    it "should create a hash representation of the element group" do
      @element_group.to_hash.should == {"group" => ["ok", {"test" => "not ok"}]}
    end
  end
end

