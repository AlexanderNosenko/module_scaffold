# frozen_string_literal: true

require_relative 'error_descriptor'
module ModuleScaffold
  module Descriptors
    class ValidationErrorDescriptor < ErrorDescriptor
      def messages
        []
      end
    end
  end
end
