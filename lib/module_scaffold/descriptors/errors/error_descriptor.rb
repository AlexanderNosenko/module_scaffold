# frozen_string_literal: true

require_relative '../rswag_descriptor'

module ModuleScaffold
  module Descriptors
    class ErrorDescriptor < RswagDescriptor
      def schema
        {
          errors: {
            type: :array,
            items: {
              type: :object,
              properties: {
                title: { type: :string },
                code: { type: :string },
                status: { type: :integer },
                detail: { type: :string },
                meta: {
                  type: :object,
                  properties: messages,
                  'x-nullable': true
                }
              }
            }
          },
          required: ['errors']
        }
      end

      def messages
        {}
      end
    end
  end
end
