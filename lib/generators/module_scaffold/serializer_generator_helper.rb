require_relative './concerns/generatable'

module ModuleScaffold
  module Generators
    class SerializerGeneratorHelper

      include Generatable

      def class_name
        "#{module_name}#{helper_type}"
      end

      def class_file_name
        "#{resource_name}_#{helper_type.downcase}.rb"
      end

      def namespace_dirs
        namespace_modules(module_full_name)[0..-2]
      end

      def permitted_attributes
        [
          :some,
          :shot,
          :ass
        ]
      end

      def permitted_attributes_formatted_str
        permitted_attributes.map do |attr|
          ":#{attr}"
        end.join(",\n")
      end

      private

      def helper_type
        'Serializer'
      end

    end
  end
end
