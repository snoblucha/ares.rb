module Ares
  module Responses
    class Standard
      # <Identification> element
      class Identification
        # WTF: addr_puv? ares_answer_v_1.0.1.xsd:56 Adr_puv = dtt:adresa_ARES

        # @!attribute [r] person
        #    @return [Person] <are:Osoba>
        # @!attribute [r] address
        #    @return [AresAddress] <are:Adresa_ARES>
        # @!attribute [r] addr_puv
        #    @return [AresAddress] <are:Adr_puv>
        attr_reader :person, :address, :addr_puv

        def initialize(elem)
          person = elem.at_xpath('./are:Osoba')
          @person = person ? Person.new(person) : nil

          if @person
            @address = @person.address
          else
            address = elem.at_xpath('./are:Adresa_ARES')
            @address = address ? AresAddress.new(address) : nil
          end

          address = elem.at_xpath('./are:Adr_puv')
          @addr_puv = address ? AresAddress.new(address) : nil
        end
      end

    end
  end
end
