# frozen_string_literal: true

module Ares
  module Client
    class BusinessRegister < Base
      ENDPOINT = 'https://wwwinfo.mfcr.cz/cgi-bin/ares/darv_or.cgi'

      private

      # Search for standard entity's identification data
      #
      # @param [Hash] opts Options for searching as specified in https://wwwinfo.mfcr.cz/ares/ares_xml_or.html.cz
      # @option opts [String] :ico
      # @option opts [Integer] :rozsah [0 - základní výpis (implicitní hodnota) ,1 provede se kompletní výpis všech dat, včetně úplné historie u subjektu, 2 -  provede se výpis aktuálních dat k zadanému dni, který je definován parametrem datum_platnosti]
      # @option opts [String] :datum_platnosti = dd.mm.rrrr - je-li rozsah=2, tak se provede výpis aktuálních dat k zadanému dni, který je ve tvaru den.měsíc.rok
      # @option opts [Integer] :xml (0) Type of xml output.
      # @option opts [String] :jazyk ('cz') Text of html pages [cz, en]
      # @option opts [String] :ver 1.0.3 - úspornější xml s názvy elementů ve zkratkách (implicitní hodnota), =1.0.2 - verze s plnými názvy elementů
      # @option opts [stdar]  ovlivní výstup xml elementů standardizované adresy (Adresa_UIR) =true - výstup bude včetně standardizované adresy, =false - výstup bude bez standardizované adresy (implicitní hodnota)
      # @returns [Ares::Responses::BusinessRegister]
      def process_response(document)
        Ares::Responses::BusinessRegister.new(document)
      end
    end
  end
end
