# frozen_string_literal: true

module ModuleScaffold
  module Serializers
    class ErrorSerializer
      attr_reader :record

      def initialize(error)
        @record = error.source
      end

      def serialized_json
        {
          errors: serialized_errors
        }
      end
    end
  end
end
