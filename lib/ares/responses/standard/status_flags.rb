module Ares
  module Responses
    class Standard
      # <Priznaky_subjektu>
      #
      # http://wwwinfo.mfcr.cz/ares/ares_xml_standard.html.en
      class StatusFlags
        attr_reader :flags

        def initialize(elem)
          flags = elem.at_xpath('./are:Priznaky_subjektu')
          @flags = flags ? flags.value : nil
        end

        def [](index)
          @flags[index]
        end

        def inspect
          "#<StatusFlags #{@flags}>"
        end
      end
    end
  end
end
