module XMLSP
	class ElementListener
		include REXML::StreamListener
		attr_reader :search_tag
		attr_accessor :on_element_parsed
		
		def initialize(tag)
		  @search_tag = tag
		  @element = nil
		  @level = 0
		end
		
		def tag_start(tag, attrs)
		  if(tag == @search_tag)
		    @in_element = true
		    @current_element = Element.new(tag, attrs)
		    @element = @current_element
		    return
		  end
		  if(@in_element)
		    @level += 1
		      child_element = Element.new(tag, attrs)
		      child_element.parent = @current_element
		      @current_element.add_element(child_element)
		      @current_element = child_element
		  end
		end
		
		def tag_end(tag)
		  if(tag == @search_tag)
		  	@on_element_parsed.call(@element) unless @on_element_parsed.nil?
		    @in_element = false
		  end
		  if(@in_element)
		      @level -= 1
		      @current_element = @current_element.parent
		  end
		end
		
		def text(text)
			text.strip!
    	if(@in_element && !text.empty?)
      	@current_element.value = text
    	end
  	end

    def cdata(content)
      content.strip!
      if(@in_element && !content.empty?)
        @current_element.value = content
      end
    end
	end
end
