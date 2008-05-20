module XMLSP
	class XMLElementGroup
		attr_accessor :elements, :tag, :parent
		
		def initialize(tag)
		  @tag = tag
		  @elements = []
		end
		
		def add_element(xml_element)
			return unless xml_element.is_a?(XMLElement)
		  @elements << xml_element
		end
	end
end
