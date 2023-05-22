module Ares
  module Responses
    class Standard
      # Ares address definition
      # ares_datatypes_v_1.0.4.xsd:788
      class AresAddress
        # Nazvy:
        # uol ico: 27074358
        # en: http://wwwinfo.mfcr.cz/cgi-bin/ares/ares_sad.cgi?zdroj=0&adr=204437556&jazyk=en
        # cs: http://wwwinfo.mfcr.cz/cgi-bin/ares/ares_sad.cgi?zdroj=0&adr=204437556

        # @!attribute [r] id
        #   @return [Integer] Address ID (ID_adresy)
        # @!attribute [r] state_code
        #   @return [Integer] State code (Kod_statu)
        # @!attribute [r] state
        #   @return [Integer] State name (Nazev_statu)
        # @!attribute [r] territory
        #   @return [Integer] Territory (Nazev_oblasti)
        # @!attribute [r] region
        #   @return [Integer] Region (Nazev_kraje)
        # @!attribute [r] district
        #   @return [Integer] District (Nazev_okresu)
        # @!attribute [r] town
        #   @return [Integer] Town (Nazev_obce)
        # @!attribute [r] residential_area
        #   @return [Integer] Residential area (Nazev_casti_obce)
        # @!attribute [r] town_district
        #   @return [Integer] Town district (Nazev_mestske_casti)
        # @!attribute [r] street
        #   @return [Integer] Street (Nazev_ulice)
        # @!attribute [r] building_number
        #   @return [Integer] Building number (Cislo_domovni)
        # @!attribute [r] sequence_number
        #   @return [Integer] Sequence number (Cislo_orientacni)
        # @!attribute [r] land_registry_number
        #   @return [Integer] Land-registry number (Cislo_do_adresy)
        # @!attribute [r] postcode
        #   @return [Integer] postcode (PSC)
        # @!attribute [r] foreign_postcode
        #   @return [Integer] Foreign postcode (Zahr_PSC)
        attr_reader :id, :state_code, :state, :territory, :region, :district,
                    :town, :residential_area, :town_district, :street,
                    :building_number, :sequence_number, :land_registry_number,
                    :postcode, :foreign_postcode

        # TODO: localize

        # @!attribute [r] pobvod
        #   @return [Integer] (Nazev_pobvodu)
        attr_reader :pobvod

        def initialize(elem)
          @id = find(elem, 'dtt:ID_adresy')
          @state_code = find(elem, 'dtt:Kod_statu')
          @state = find(elem, 'dtt:Nazev_statu')
          @territory = find(elem, 'dtt:Nazev_oblasti')
          @region = find(elem, 'dtt:Nazev_kraje')
          @district = find(elem, 'dtt:Nazev_okresu')
          @town = find(elem, 'dtt:Nazev_obce')
          @pobvod = find(elem, 'dtt:Nazev_pobvodu')
          @residential_area = find(elem, 'dtt:Nazev_casti_obce')
          @town_district = find(elem, 'dtt:Nazev_mestske_casti')
          @street = find(elem, 'dtt:Nazev_ulice')
          @building_number = find(elem, 'dtt:Cislo_domovni')
          @sequence_number = find(elem, 'dtt:Cislo_orientacni')
          @land_registry_number = find(elem, 'dtt:Cislo_do_adresy')
          @postcode = find(elem, 'dtt:PSC')
          @foreign_postcode = find(elem, 'dtt:Zahr_PSC')
          @text = find(elem, 'dtt:Adresa_textem')
        end

        def inspect
          "#<AresAddress \"#{@id || @text}\""
        end

        # TODO: localize
        # @param lang [String] ('cz') Language
        #
        # rubocop:disable Metrics/BlockNesting
        def to_s(lang = 'cz')
          s = ''
          if street
            s << street
            s << " #{land_registry_number}" if land_registry_number
            if sequence_number || building_number
              s << ' '
              s << sequence_number if sequence_number
              s << '/' if building_number && sequence_number
              s << building_number if building_number
            end
            s << ", #{postcode} #{town}"
            if residential_area
              s << (town =~ /-/ ? ',' : '-') if town
              s << residential_area
            end
          else
            s << "#{postcode} #{town}"
            if residential_area
              s << '-' if town
              s << residential_area
            end
            s << " #{land_registry_number}" if land_registry_number
            if land_registry_number && building_number
              s << ' '
              s << sequence_number if sequence_number
              s << '/' if building_number && sequence_number
              s << building_number if building_number
            end
          end
          if lang == 'en'
            s << ", District: #{district}" if district
            s << ", State: #{state}" if state
          else
            s << ", okres: #{district}" if district
            s << ", stát: #{state}" if state
          end
          s
        end

        # rubocop:enable Metrics/BlockNesting

        private

        def find(elem, path)
          res = elem.at_xpath("./#{path}")
          res.nil? ? nil : res.content
        end
      end

    end
  end
end
