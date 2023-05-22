module Ares
  module Responses
    class Standard
      # <Osoba> element
      class Person
        attr_reader :title_before, :name, :last_name, :title_after,
                    :birthdate, :personal_id_number, :text, :address

        def initialize(elem)
          @title_before = elem.at_xpath('./dtt:Titul_pred')
          @name = elem.at_xpath('./dtt:Jmeno')
          @last_name = elem.at_xpath('./dtt:Prijmeni')
          @title_after = elem.at_xpath('./dtt:Titul_za')
          @birthdate = elem.at_xpath('./dtt:Datum_narozeni')
          @personal_id_number = elem.at_xpath('./dtt:Rodne_cislo')
          @text = elem.at_xpath('./dtt:Osoba_textem')
          address = elem.at_xpath('./dtt:Bydliste')
          @address = address ? AresAddress.new(address) : nil
        end
      end

    end
  end
end
