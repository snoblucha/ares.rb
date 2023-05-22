module Ares
  module Responses
    class Standard
      # <are:Odpoved> element
      class Response
        include Enumerable

        # @!attribute [r] id
        #   @return [Integer] id
        # @!attribute [r] count
        #   @return [Integer] Responses count
        # @!attribute [r] search_type
        #   @return [String] type of search:
        #     * FREE - searching by ico, if not found search
        #              by RC, if not found find by company's name
        #     * ICO, RC, OF - search by type, if not found searching ends.
        #     Searching type is shown in (Kod_shody_*) element.
        #
        # @!attribute [r] records
        #    @return [Record, Error] Found records
        attr_reader :id, :count, :search_type, :records

        # @param elem [Nokogiri::XML::Element]
        def initialize(elem)
          @id = @count = @search_type = nil
          @records = []
          elem.children.each { |child| parse_elem(child) }
        end

        def each(&block)
          @records.each(&block)
        end

        def error?
          @records.any? { |e| e.is_a? Responses::Error }
        end

        private

        # @param child [Nokogiri::XML::Element] Child element
        # rubocop:disable Lint/EmptyWhen
        def parse_elem(child)
          case child.name
          when 'Pomocne_ID'
            @id = child.value
          when 'Pocet_zaznamu'
            @count = child.content.to_i
          when 'Typ_vyhledani'
            @search_type = child.content
          when 'Error'
            @records << Ares::Responses::Error.new(
              child,
              child.at_xpath('./Error_kod/text()').to_s,
              child.at_xpath('./Error_text/text()').to_s
            )
          when 'Zaznam'
            @records << Record.new(child)
          when 'text'
            # do nothing
          else
            Ares.logger.warn("#{self}: Unexpected record #{child.name} at #{child.path}")
          end
        end
        # rubocop:enable Lint/EmptyWhen
      end
    end
  end
end
