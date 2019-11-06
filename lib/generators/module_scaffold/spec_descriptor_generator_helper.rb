require_relative './concerns/generatable'

module ModuleScaffold
  module Generators
    class SpecDescriptorGeneratorHelper

      include Generatable

      def class_name
        "#{module_name}#{helper_type}"
      end

      def class_file_name
        "#{resource_name}_#{helper_type.downcase}.rb"
      end

      def files_dir
        directory_path = ['spec', helper_type.downcase.pluralize]
        directory_path += namespace_dirs.map(&:downcase)
        directory_path.join('/')
      end

      def namespace_dirs
        namespace_modules(module_full_name)[0..-2]
      end

      def format_attr_str(attr)
        "#{attr}: { type: :string, 'x-nullable': true }"
      end

      private

      def helper_type
        'Descriptor'
      end

    end
  end
end
