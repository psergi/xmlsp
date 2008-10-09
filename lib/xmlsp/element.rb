module XMLSP
	class Element
		attr_accessor :children, :parent, :attributes, :text, :tag
		
		def initialize(tag, text = nil, attributes = {})
		  @tag = tag
      @text = text
		  @attributes = attributes
		end
		
		def parent?
		  !@children.nil?
		end
		
		def add_element(xml_element)
		  return unless xml_element.is_a?(Element)
		  @children ||= {}
		  if(@children[xml_element.tag].nil?)
		    @children[xml_element.tag] = xml_element
		  elsif(@children[xml_element.tag].is_a?(ElementGroup))
		    @children[xml_element.tag] << xml_element
		  else
		    xml_element_group = ElementGroup.new(xml_element.tag)
		    xml_element_group.parent = self
		    xml_element_group << @children[xml_element.tag]
		    xml_element_group << xml_element
		    @children[xml_element.tag] = xml_element_group
		  end
		end

    alias_method :<<, :add_element
		
		def [](tag)
			return parent? ? @children[tag] : nil
		end
    
    def to_hash
      key = @tag
      if(parent?)
        value = {}
        @children.each_value do |v|
          value.merge!(v.to_hash)
        end
      else
        value = @text
      end
      {key => value}
    end
	end
end
