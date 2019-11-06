require_relative './concerns/generatable'

module ModuleScaffold
  module Generators
    class IntegrationSpecGeneratorHelper

      include Generatable

      def class_name
        module_name.pluralize
      end

      def class_file_name
        "#{class_name.underscore}_spec.rb"
      end

      def files_dir
        directory_path = ['spec', helper_type.downcase]
        directory_path += namespace_dirs.map(&:downcase)
        directory_path.join('/')
      end

      def namespace_dirs
        namespace_modules(module_full_name)[0..-2]
      end

      def descriptor_class_name
        "#{module_full_name}Descriptor"
      end

      def index_route_str
        @controller_helper = ControllerGeneratorHelper.new(module_full_name, options)
        dirs = @controller_helper.namespace_dirs
        dirs += [class_name.underscore.pluralize]
        "/#{dirs.map(&:downcase).join('/')}"
      end

      def sample_attribute_name
        @sample_attribute_name ||= begin
          @policy_helper = PolicyGeneratorHelper.new(module_full_name)
          @policy_helper.permitted_attributes.first
        end
      end

      def sample_param_reference
        "params[:#{resource_name}][:#{sample_attribute_name}]"
      end

      def route_id_param
        "#{resource_name}_id"
      end

      private

      def helper_type
        'Integration'
      end

    end
  end
end
