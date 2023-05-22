module Ares
  module Responses
    class BusinessRegister  < Base
      def initialize(xml_document)
        @response_hash = Hash.from_xml(xml_document)
        @base_response = @response_hash.values.first
        assign_base_attributes(@base_response)
        @content = @base_response.map { |key, value| parse_elem(key, value) }.compact
      end
    end
  end
end
