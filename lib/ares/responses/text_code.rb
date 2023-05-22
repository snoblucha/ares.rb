module Ares
  module Responses
    class TextCode
      attr_reader :elem, :code, :text

      def initialize(elem, code, text)
        @elem = elem
        @code = code
        @text = text
      end

      def to_s
        "#{@code}: #{text}"
      end

      def inspect
        "#<TextCode(#{elem}) code=#{code} text=#{text}>"
      end
    end
  end
end
