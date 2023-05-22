module Ares
  module Responses
    class Standard
      # <Pravni_forma> element
      class LegalForm
        # Typ ekonomickeho subjektu:
        # F-fyzicka osoba tuzemska,
        # P-pravnicka osoba tuzemska,
        # X-zahranicni pravnicka osoba,
        # Z-zahranicni fyzicka osoba,
        # O-fyzicka osoba s organizacni slozkou
        # C-civilni osoba nepodnikajici (v CEU)
        attr_reader :code, :name, :person, :text, :person_type

        def initialize(elem)
          code = elem.at_xpath('./dtt:Kod_PF')
          @code = code ? code.content.to_i : nil
          name = elem.at_xpath('./dtt:Nazev_PF')
          @name = name ? name.content : nil
          person = elem.at_xpath('./dtt:PF_osoba')
          @person = person ? person.content : nil
          @text = elem.xpath('./dtt:Text').map(&:content).join("\n")
          person_type = elem.at_xpath('./dtt:TZU_osoba')
          @person_type = person_type ? person_type.content : nil
        end
      end
    end
  end
end
