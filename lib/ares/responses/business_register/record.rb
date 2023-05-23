module Ares
  module Responses
    class BusinessRegister # <D:Vypis_OR> element
      class Record
        # @!attribute [r] registration
        #    @return [Registration] <D:REG>
        attr_reader :registration, :texts, :introduction

        def initialize(elem)

          @texts = elem.xpath('./D:OSK').map do |text|
            text.content.strip
          end
          @registration = Registration.new(elem.at_xpath('./D:REG'))
          @introduction = Introduction.new(elem.at_xpath('./D:UVOD'))
        end

        # Returns company's address or nil if not specified
        #
        # @returns [AresAddress, NilClass] Address
        def address
          return unless identification

          identification.address
        end

        private

      end
    end
  end
end
