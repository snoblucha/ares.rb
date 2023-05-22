##
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize
#
module Ares
  module Responses
    # Coresponds to <are:Ares_odpovedi> element.
    class Standard < Base
      def initialize(xml_document)
        @xml_document = xml_document
        assign_base_attributes(xml_document.root.attributes)
        @content = xml_document.root.children.map { |elem| parse_elem elem }.compact
      end

      private

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
        end
      end
    end
  end
end
#
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/MethodLength
# rubocop:enable Metrics/AbcSize
##
