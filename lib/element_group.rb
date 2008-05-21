module XMLSP
	class ElementGroup
		attr_accessor :elements, :tag, :parent
		
		def initialize(tag)
		  @tag = tag
		  @elements = []
		end
		
		def add_element(xml_element)
			return unless xml_element.is_a?(Element)
		  @elements << xml_element
		end
	end
end
