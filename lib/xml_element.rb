module XMLSP
	class XMLElement
		attr_accessor :children, :parent, :attributes, :value, :tag
		
		def initialize(tag)
		  @tag = tag
		end
		
		def is_parent?
		  !@children.nil?
		end
		
		def add_element(xml_element)
		  return unless xml_element.is_a?(XMLElement)
		  @children ||= {}
		  if(@children[xml_element.tag].nil?)
		    @children[xml_element.tag] = xml_element
		  elsif(@children[xml_element.tag].is_a?(XMLElementGroup))
		    @children[xml_element.tag].add_element(xml_element)
		  else
		    xml_element_group = XMLElementGroup.new(xml_element.tag)
		    xml_element_group.parent = self
		    xml_element_group.add_element(@children[xml_element.tag])
		    xml_element_group.add_element(xml_element)
		    @children[xml_element.tag] = xml_element_group
		  end
		end
		
		def [](tag)
			return nil unless is_parent?
			return @children[tag]
		end
		
		def inspect
			@value
		end
	end
end
