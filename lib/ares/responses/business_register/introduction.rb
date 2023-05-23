module Ares
  module Responses
    class BusinessRegister
      # <D:REG> element
      class Introduction

        # Nadpis Aktualizace_DB Datum_vypisu Cas_vypisu Typ_odkazu
        # <D:UVOD>
        # <D:ND>Výpis z dat Obchodního Rejstříku v ARES</D:ND>
        # <D:ADB>2023-05-23</D:ADB>
        # <D:DVY>2023-05-23</D:DVY>
        # <D:CAS>13:28:59</D:CAS>
        # <D:TV>aktualni</D:TV>
        # <D:Typ_odkazu>0</D:Typ_odkazu>
        # </D:UVOD>
        attr_reader :title, :updated_ad, :listed_at, :listed_at_time, :link_type, :list_type

        # @param elem [Nokogiri::XML::Element]
        def initialize(elem)
          @title = elem.at_xpath('./D:ND').content
          @updated_at = elem.at_xpath('./D:ADB').content
          @listed_at = elem.at_xpath('./D:DVY').content
          @listed_at_time = elem.at_xpath('./D:CAS').content
          @link_type = elem.at_xpath('./D:Typ_odkazu').content
          @list_type = elem.at_xpath('./D:TV').content
        end

        # rubocop:enable Lint/EmptyWhen
      end
    end
  end
end
