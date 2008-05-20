module XMLSP
	class ItemListener
		include REXML::StreamListener
		attr_reader :search_element
		attr_accessor :on_item_parsed
		
		def initialize(element)
		  @search_element = element
		  @item = nil
		  @level = 0
		end
		
		def tag_start(name, attrs)
		  if(name == @search_element)
		    @in_search_element = true
		    @current_element = XMLElement.new(name)
		    @item = @current_element
		    return
		  end
		  if(@in_search_element)
		    @level += 1
		      child_element = XMLElement.new(name)
		      child_element.parent = @current_element
		      @current_element.add_element(child_element)
		      @current_element = child_element
		  end
		end
		
		def tag_end(name)
		  if(name == @search_element)
		    if(!@on_item_parsed.nil?)
		      @on_item_parsed.call(@item)
		    end
		    @in_search_element = false
		  end
		  if(@in_search_element)
		      @level -= 1
		      @current_element = @current_element.parent
		  end
		end
		
		def text(text)
		text.strip!
    if(@in_search_element && !text.empty?)
      @current_element.value = text
    end
  end
	end
end
