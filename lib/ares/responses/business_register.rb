module Ares
  module Responses
    class BusinessRegister  < Base
      def initialize(xml_document)
        assign_base_attributes(xml_document.root.attributes)
        @content = xml_document.root.children.map { |elem| parse_elem elem }.compact
      end

      def parse_elem(elem)
        case elem.name
        when 'Fault'
          Ares::Responses::Error.new(
            elem,
            elem.at_xpath('./faultcode/text()').to_s,
            elem.at_xpath('./faultstring/text()').to_s
          )
        when 'Odpoved'
          Response.new(elem)
        when 'text'
          # do nothing
        else
          nil
        end
      end
    end
  end
end
