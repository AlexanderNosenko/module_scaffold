# frozen_string_literal: true

module ModuleScaffold
  module Errors
    class BaseError < StandardError
      attr_reader :source

      def initialize(source = nil)
        super(title)
        @source = source
      end

      # DSL for nicely setting error values
      # def code, def http_code, def title, def detail, def source
      %i[code http_code title details].each do |method_name|
        define_singleton_method method_name do |val|
          define_method(method_name) { val }
        end
      end
    end
  end
end
