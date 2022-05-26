module Ares
  module Responses
    class Basic < Base
      def initialize(xml_document)
        @response_hash = Hash.from_xml(xml_document)
        @base_response = @response_hash.values.first

        assign_base_attributes(@base_response)

        @content = @base_response.map { |key, value| parse_elem(key, value) }.compact
      end

      def error?
        @content.any? { |e| e.is_a? Ares::Responses::Error }
      end

      def record
        response
      end

      def parse_elem(key, value)
        case key
        when 'Fault'
          Ares::Responses::Error.new(
            value,
            value['faultcode'].to_s,
            value['faultstring'].to_s
          )
        when 'Odpoved'
          Response.new(value)
        end
      end

      class Base
        # rubocop:disable Metrics/MethodLength
        # rubocop:disable Metrics/AbcSize
        def initialize(value)
          self.class.class_eval do
            if const_defined?(:ATTRIBUTES)
              attr_reader(*const_get(:ATTRIBUTES).map(&:parameterize))
            end
            if const_defined?(:COMPOSITE_ATTRIBUTES)
              attr_reader(*const_get(:COMPOSITE_ATTRIBUTES)
                .values.map(&:parameterize))
            end
          end

          return unless value

          if self.class.const_defined?(:ATTRIBUTES)
            self.class::ATTRIBUTES.each do |attribute|
              instance_variable_set("@#{attribute.parameterize}",
                                    value[attribute].presence)
            end
          end
          self.class::COMPOSITE_ATTRIBUTES.each do |class_name, key|
            full_class = "Ares::Responses::Basic::#{class_name}".constantize
            instance_variable_set("@#{key.parameterize}",
                                  full_class.new(value[key].presence))
          end if self.class.const_defined?(:COMPOSITE_ATTRIBUTES)
        end
        # rubocop:enable Metrics/AbcSize
        # rubocop:enable Metrics/MethodLength
      end

      class Response < Base
        ATTRIBUTES = %w[Pomocne_ID Vysledek_hledani Pocet_zaznamu].freeze

        COMPOSITE_ATTRIBUTES = {
          Introduction: 'Uvod',
          Record: 'Vypis_basic'
        }.freeze
      end

      class Record < Base

        ##
        # Další informace o subjektu:
        # Služba Basic vrací kromě základních údajů o subjektu další informace specifické pro jednotlivé zdroje, např. registrační úřady, texty živnostenských oprávnění, předměty činnosti, hodnoty CZ-NACE, statistické charakteristiky.
        #
        # Součástí výstupu je i seznam registrací v jednotlivých zdrojových registrech v elementu Priznaky_subjektu s označením, zda má subjekt v příslušném registru platnou či zrušenou registraci.
        #
        # Význam písmen v elementu:
        #
        # A	platná registrace
        # Z	zaniklá registrace
        # H	zaniklá registrace déle než 4 roky
        # S	v pozici č. 6 označuje skupinovou registraci DPH
        # P	v pozici č. 15 označuje pozastavenou činnost, v pozici č. 21 platnou registraci ve Společném zemědělském registru
        # E	v pozici č. 22 označuje, že existuje záznam v Insolvenčním rejstříku. Nutno prověřit stav řízení!
        # N (nebo jiný znak)	není v evidenci
        # Poznámka: mohou se objevit i další "služební" znaky, které všechny lze interpretovat jako příznak "N".
        #
        # Význam pozic v elementu:
        #
        # 1	rezervováno
        # 2	příznak existence subjektu ve Veřejném rejstříku
        # 3	příznak existence subjektu ve statistickém Registru ekonomických subjektů
        # 4	příznak existence subjektu v Registru živnostenského podnikání
        # 5	příznak existence subjektu v Národním registru poskytovatelů zdravotních služeb
        # 6	příznak existence subjektu v Registru plátců daně z přidané hodnoty
        # 7	příznak existence subjektu v Registru plátců spotřební daně
        # 8	rezervováno
        # 9	příznak existence subjektu v registru Centrální evidence úpadců - konkurz
        # 10	příznak existence subjektu v registru Centrální evidence úpadců - vyrovnání
        # 11	příznak existence subjektu v registru Centrální evidence dotací z rozpočtu
        # 12	příznak existence subjektu v účelovém registru organizací systému ARIS
        # 13	rezervováno
        # 14	příznak existence subjektu v Registru církví a náboženských společností
        # 15	příznak existence subjektu v Seznamu politických stran a hnutí
        # 16	rezervováno
        # 17	rezervováno
        # 18	rezervováno
        # 19	rezervováno
        # 20	rezervováno
        # 21	příznak existence subjektu v Zemědělském registru
        # 22	příznak existence subjektu v Insolvenčním rejstříku
        # 23	příznak existence subjektu v Rejstříku škol a školských zařízení
        # 24	rezervováno
        # 25	příznak existence subjektu v Registru osob
        # 26 - 30	rezervováno

        ATTRIBUTES = %w[ICO DIC Obchodni_firma Datum_vzniku Adresa_ARES Priznaky_subjektu
                        Kategorie_poctu_pracovniku].freeze

        COMPOSITE_ATTRIBUTES = {
          LegalForm: 'Pravni_forma',
          SendingAddress: 'Adresa_dorucovaci',
          Address: 'Adresa_ARES',
          CzNace: 'Nace',
          RegisteredInstitution: 'Registrace_RZP'
        }.freeze


        ##
        # S	v pozici č. 6 označuje skupinovou registraci DPH
        # 6	příznak existence subjektu v Registru plátců daně z přidané hodnoty
        def vat_payer?
          priznaky_subjektu[5] == 'A' || group_vat_payer?
        end

        def group_vat_payer?
          priznaky_subjektu[5] == 'S'
        end

        # 22	příznak existence subjektu v Insolvenčním rejstříku
        def insolvent?
          priznaky_subjektu[5] == 'N'
        end

      end

      class RegisteredInstitution < Base
        COMPOSITE_ATTRIBUTES = {
          BusinessOffice: 'Zivnostensky_urad',
          FinanceOffice: 'Financni_urad'
        }.freeze
      end

      class BusinessOffice < Base
        ATTRIBUTES = %w[Kod_ZU Nazev_ZU].freeze
      end

      class FinanceOffice < Base
        ATTRIBUTES = %w[Kod_FU Nazev_FU].freeze
      end

      class CzNace < Base
        ATTRIBUTES = %w[NACE].freeze
      end

      class SendingAddress < Base
        ATTRIBUTES = %w[zdroj Ulice_cislo PSC_obec].freeze
      end

      class Address < Base
        ATTRIBUTES = %w[zdroj ID_adresy Kod_statu Nazev_statu Nazev_okresu Nazev_obce
                        Nazev_casti_obce Nazev_mestske_casti Nazev_ulice Cislo_domovni
                        Typ_cislo_domovni Cislo_orientacni PSC].freeze

        COMPOSITE_ATTRIBUTES = {
          AddressUIR: 'Adresa_UIR'
        }.freeze
      end

      class AddressUIR < Base
        ATTRIBUTES = %w[Kod_oblasti Kod_kraje Kod_okresu Kod_obce Kod_pobvod Kod_sobvod
                        Kod_casti_obce Kod_mestske_casti PSC Kod_ulice Cislo_domovni
                        Typ_cislo_domovni Cislo_orientacni Kod_adresy Kod_objektu
                        PCD].freeze
      end

      class LegalForm < Base
        ATTRIBUTES = %w[zdroj Kod_PF Nazev_PF].freeze
      end

      class Introduction < Base
        ATTRIBUTES = %w[Nadpis Aktualizace_DB Datum_vypisu Cas_vypisu Typ_odkazu].freeze
      end
    end
  end
end
