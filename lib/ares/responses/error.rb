# frozen_string_literal: true

module Ares
  module Responses
    class Error < TextCode
      def error?
        true
      end
    end
  end
end
