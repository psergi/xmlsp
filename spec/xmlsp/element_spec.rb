require File.dirname(__FILE__) + '/../spec_helper.rb'

describe XMLSP::Element do
  describe "attributes" do
    before(:each) do
      @element = XMLSP::Element.new('name')
    end
    it "should have children attribute" do
      @element.should respond_to(:children)
    end
    it "should have parent attribute" do
      @element.should respond_to(:parent)
    end
    it "should have attributes attribute" do
      @element.should respond_to(:attributes)
    end
    it "should have text attribute" do
      @element.should respond_to(:text)
    end
    it "should have tag attribute" do
      @element.should respond_to(:tag)
    end
  end

  describe ".initialize" do
    before(:each) do
      @element = XMLSP::Element.new('name')
    end
    it "should create an element with tag name given" do
      @element.tag.should == "name"
    end
    it "should set default attributes to {}" do
      @element.attributes.should == {}
    end
    it "should set default text to nil" do
      @element.text.should be_nil
    end
    it "should be able to set text when created" do
      text = "this text"
      element = XMLSP::Element.new("name", {}, text)
      element.text.should == text
    end
    it "should be able to set attributes when created" do
      attrs = {:this => "that", :ok => "false"}
      element = XMLSP::Element.new("name", attrs, "text")
      element.attributes.should == attrs
    end
    it "should not have a parent by default" do
      @element.parent.should be_nil
    end
    it "should not have any children" do
      @element.children.should be_nil
    end
    it "should not be a parent" do
      @element.should_not be_parent
    end
  end

  describe ".add_element" do
    before(:each) do
      @element = XMLSP::Element.new("parent")
      @child = XMLSP::Element.new("child")
      @child2 = XMLSP::Element.new("child")
    end
    it "should add child element to parent elements children" do
      @element.add_element(@child)
      @element.children["child"].should == @child
    end
    it "should set child's parent" do
      @element.add_element(@child)
      @child.parent.should == @element
    end
    it "should create element group of children with the same name" do
      @element.add_element(@child)
      @element.add_element(@child2)
      @element.children["child"].should be_kind_of(XMLSP::ElementGroup)
      @element.children["child"].elements.should == [@child, @child2]
    end
    it "should add to element group when another child element is added" do
      child3 = XMLSP::Element.new("child")
      @element.add_element(@child)
      @element.add_element(@child2)
      @element.add_element(child3)
      @element.children["child"].elements.should == [@child, @child2, child3]
    end
    it "should return nil if non Element is passed" do
      @element.add_element("test").should == nil
      @element.children.should be_nil
    end
    it "should be aliased as <<" do
      @element << @child
      @element << @child2
      @element.children["child"].elements.should == [@child, @child2]
    end
  end

  describe ".[]" do
    before(:each) do
      @element = XMLSP::Element.new("parent")
    end
    it "should return nil if element does not have a child element of the given tag" do
      @element["child"].should be_nil
    end
    it "should return child element of the given tag (when exists)" do
      child = XMLSP::Element.new("child")
      @element.add_element(child)
      @element["child"].should == child
    end
  end

  describe ".to_hash" do
    before(:each) do
      @root = XMLSP::Element.new("root")
      @child1 = XMLSP::Element.new("child", {}, "child #1")
      @child2 = XMLSP::Element.new("child", {}, "child #2")
      @child3 = XMLSP::Element.new("child")
      @grand_child = XMLSP::Element.new("grandchild", {}, "grand child")
      @dog = XMLSP::Element.new("dog")
      @root.add_element(@child1)
      @root.add_element(@child2)
      @child3.add_element(@grand_child)
      @root.add_element(@child3)
      @root.add_element(@dog)
    end
    it "should create a hash representation of the elements" do
      @root.to_hash.should == {
        "root" => {
          "child" => ["child #1", "child #2", {"grandchild" => "grand child"}],
          "dog" => nil}
        }
    end
    it "should work with a single element" do
      XMLSP::Element.new("root", {}, "this one").to_hash.should == {"root" => "this one"}
    end
    it "should work with a no text single element" do
      XMLSP::Element.new("root").to_hash.should == {"root" => nil}
    end
  end
end
