module XMLSP
	class ElementGroup
		include Enumerable
		
		attr_accessor :elements, :tag, :parent
		
		def initialize(tag)
		  @tag = tag
		  @elements = []
		end
		
		def add_element(xml_element)
			return unless xml_element.is_a?(Element)
		  @elements << xml_element
		end

    alias_method :<<, :add_element
		
		def each()
			@elements.each {|e| yield e}
		end
		
		def [](i)
			@elements[i]
		end
    

    def to_hash
      {@tag => @elements.map { |e| e.to_hash[@tag] }}
    end
	end
end
