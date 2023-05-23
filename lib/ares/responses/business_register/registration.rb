module Ares
  module Responses
    class BusinessRegister
      # <D:REG> element
      class Registration

        # <D:REG>
        #   <D:SZ>
        #    <D:SD>
        #      <D:K>1</D:K>
        #      <D:T>Městský soud v Praze</D:T>
        #    </D:SD>
        #    <D:OV>B 8525</D:OV>
        #   </D:SZ>
        # </D:REG>
        attr_reader :court, :number

        # @param elem [Nokogiri::XML::Element]
        def initialize(elem)
          @court = elem.at_xpath('./D:SZ/D:SD/D:T').content
          @number = elem.at_xpath('./D:SZ/D:OV').content
        end

        # rubocop:enable Lint/EmptyWhen
      end
    end
  end
end
