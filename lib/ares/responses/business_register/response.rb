module Ares
  module Responses
    class BusinessRegister
      # <are:Odpoved> element
      class Response
        include Enumerable

        # <D:PID>0</D:PID>
        # <D:VH>
        # ...
        # </D:VH>
        # <D:PZA>1</D:PZA>
        # <D:Vypis_OR>...</D:Vypis_OR>
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
          when 'PID'
            @id = child.content.to_i
          when 'PZA'
            @count = child.content.to_i
          when 'VH'
            @search_type = child.content
          when 'Error'
            @records << Ares::Responses::Error.new(
              child,
              child.at_xpath('./Error_kod/text()').to_s,
              child.at_xpath('./Error_text/text()').to_s
            )
          when 'Vypis_OR'
            @records << ::Ares::Responses::BusinessRegister::Record.new(child)
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
