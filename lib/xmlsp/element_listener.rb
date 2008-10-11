module XMLSP
  class ElementListener
    include REXML::StreamListener
    attr_accessor :on_element_parsed, :search_tag
    
    def initialize(tag)
      @search_tag = tag
      @element = nil
    end
    
    def tag_start(tag, attrs)
      if(tag == @search_tag)
        @in_element = true
        @current_element = XMLSP::Element.new(tag, attrs)
        @element = @current_element
        return
      end
      if(@in_element)
        child_element = XMLSP::Element.new(tag, attrs)
        @current_element << child_element
        @current_element = child_element
      end
    end
    
    def tag_end(tag)
      return unless @in_element
      if(tag == @search_tag)
        @on_element_parsed.call(@element) unless @on_element_parsed.nil?
        @in_element = false
      end
      @current_element = @current_element.parent
    end
    
    def text(text)
      @current_element.text = text.strip if @in_element
    end

    def cdata(content)
      @current_element.text = content.strip if @in_element
    end
  end
end
