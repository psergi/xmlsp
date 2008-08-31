module XMLSP
	class Element
		attr_accessor :children, :parent, :attributes, :value, :tag
		
		def initialize(tag, attributes = {})
		  @tag = tag
		  @attributes = attributes
		end
		
		def is_parent?
		  !@children.nil?
		end
		
		def add_element(xml_element)
		  return unless xml_element.is_a?(Element)
		  @children ||= {}
		  if(@children[xml_element.tag].nil?)
		    @children[xml_element.tag] = xml_element
		  elsif(@children[xml_element.tag].is_a?(ElementGroup))
		    @children[xml_element.tag].add_element(xml_element)
		  else
		    xml_element_group = ElementGroup.new(xml_element.tag)
		    xml_element_group.parent = self
		    xml_element_group.add_element(@children[xml_element.tag])
		    xml_element_group.add_element(xml_element)
		    @children[xml_element.tag] = xml_element_group
		  end
		end
		
		def [](tag)
			return is_parent? ? @children[tag] : nil
		end
		
		def inspect
			@value
		end
    
    def to_hash
      key = @tag
      if(is_parent?)
        value = {}
        @children.each_value do |v|
          value.merge!(v.to_hash)
        end
      else
        value = @value
      end
      {key => value}
    end
	end
end
