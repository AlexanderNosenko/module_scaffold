# frozen_string_literal: true

module ModuleScaffold
  module Serializers
    class ValidationErrorSerializer < ErrorSerializer
      def serialized_errors
        record.errors.details.flat_map do |field, details|
          details.map do |error_details|
            error_name = error_details[:error].to_s

            serialized_error(field, error_name)
          end
        end
      end

      def serialized_error(field, error)
        {
          source: { pointer: "/data/attributes/#{field}" },
          detail: error
        }
      end
    end
  end
end
