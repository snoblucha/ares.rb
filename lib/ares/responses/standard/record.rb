module Ares
  module Responses
    class Standard # <are:Zaznam> element
      class Record
        # @!attribute [r] match
        #    @return [Responses::TextCode] <are:Shoda_ICO/RC/OF>
        #               Code of matching register ('ICO', 'RC', 'OF')
        # @!attribute [r] search_by
        #    @return [String] <are:Vyhledano_dle> Register where record was found
        # @!attribute [r] register_type
        #    @return [String] <are:Typ_registru> Register code
        # @!attribute [r] creation_date
        #    @return [String] <are:Datum_vzniku> Date of creation
        # @!attribute [r] termination_date
        #    @return [String] <are:Datum_zaniku> Date of termination
        # @!attribute [r] validity_date
        #    @return [String] <are:Datum_platnosti>
        # @!attribute [r] legal_form
        #    @return [LegalForm] <are:Pravni_forma>
        # @!attribute [r] bussiness_name
        #    @return [String] <are:Obchodni_firma>
        # @!attribute [r] ico
        #    @return [String] <are:ICO>
        # @!attribute [r] identification
        #    @return [Identification] <are:Identifikace>
        # @!attribute [r] tax_office_code
        #    @return [String] <are:Kod_FU>
        # @!attribute [r] status_flags
        #    @return [Flags] <are:Priznaky_subjektu>
        attr_reader :match, :search_by, :register_type,
                    :creation_date, :termination_date, :validity_date,
                    :legal_form, :business_name, :ico, :identification,
                    :tax_office_code, :status_flags

        def initialize(elem)
          @match = get_match(elem)
          @search_by = elem.at_xpath('./are:Vyhledano_dle').content
          @register_type = TextCode
                             .new('RegisterType',
                                  elem.at_xpath('./are:Typ_registru/dtt:Kod').content,
                                  elem.at_xpath('./are:Typ_registru/dtt:Text').content)
          date = elem.at_xpath('./are:Datum_vzniku')
          @creation_date = date ? Time.parse(date.content) : nil
          date = elem.at_xpath('./are:Datum_zaniku')
          @termination_date = date ? Time.parse(date.content) : nil
          date = elem.at_xpath('./are:Datum_platnosti')
          @validity_date = date ? Time.parse(date.content) : nil

          @legal_form = LegalForm.new(elem.at_xpath('./are:Pravni_forma'))
          @business_name = elem.at_xpath('./are:Obchodni_firma').content
          @ico = elem.at_xpath('./are:ICO').content
          id_elem = elem.at_xpath('./are:Identifikace')
          @identification = id_elem ? Identification.new(id_elem) : nil
          fu_code = elem.at_xpath('./are:Kod_FU')
          @tax_office_code = fu_code ? fu_code.content.to_i : nil
          flags = elem.at_xpath('./are:Priznaky_subjektu')
          @status_flags = flags ? StatusFlags.new(flags) : nil
        end

        # Returns company's address or nil if not specified
        #
        # @returns [AresAddress, NilClass] Address
        def address
          return unless identification

          identification.address
        end

        private

        def get_match(elem)
          name = code = text = nil
          if (match = elem.at_xpath('./are:Shoda_ICO'))
            name = 'Match ICO'
            code = match.at_xpath('./dtt:Kod').content
            text = match.at_xpath('./dtt:Text')
            text = (text ? text.content : nil)
          elsif (match = elem.at_xpath('./are:Shoda_RC'))
            name = 'Match RC'
            code = match.at_xpath('./dtt:Kod').content
            text = match.at_xpath('./dtt:Text')
            text = (text ? text.content : nil)
          elsif (match = elem.at_xpath('./are:Shoda_OF'))
            name = 'Match OF'
            code = match.at_xpath('./dtt:Kod').content
            text = match.at_xpath('./dtt:Text')
            text = (text ? text.content : nil)
          else
            return nil
          end

          TextCode.new(name, code, text)
        end
      end
    end
  end
end
