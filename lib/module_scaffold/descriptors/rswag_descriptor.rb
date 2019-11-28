# frozen_string_literal: true

module ModuleScaffold
  module Descriptors
    class RswagDescriptor
      attr_reader :options

      def initialize(**options)
        @options = options
      end

      def self.schema(**options)
        new(**options).schema
      end
    end
  end
end
