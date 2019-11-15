# TODO: Misc
#   * Add relations descriptors generator integration.erb
#   * add more features to specs
#
require_relative './generator_helpers'
require_relative './controller_generator_helper'
require_relative './service_generator_helper'
require_relative './policy_generator_helper'
require_relative './serializer_generator_helper'
require_relative './service_spec_generator_helper'
require_relative './integration_spec_generator_helper'
require_relative './spec_descriptor_generator_helper'
require_relative './policy_spec_generator_helper'
require_relative './serializer_spec_generator_helper'

module ModuleScaffold
  module Generators
    class ModuleGenerator < Rails::Generators::NamedBase

      source_root File.expand_path('../templates', __FILE__)

      class_option :routes_namespace, type: :string, default: '', desc: 'Routes namespace'
      class_option :controller_actions, type: :array, default: ControllerGeneratorHelper.new(nil).actions, desc: 'Desired controller actions'
      class_option :only, type: :array, default: [], desc: 'Runs only specified generators'
      class_option :except, type: :array, default: [], desc: 'Does not run specified generators'

      desc "Generates service oriented CRUD scaffold for an existing Model"

      include GeneratorHelpers

      def initialize_helpers
        name.constantize rescue raise "Model #{name} is not defined"

        @controller_helper = ControllerGeneratorHelper.new(name, options)
        @policy_helper = PolicyGeneratorHelper.new(name)
        @services_helper = ServiceGeneratorHelper.new(name, options)
        @serializer_helper = SerializerGeneratorHelper.new(name)
        @services_specs_helper = ServiceSpecGeneratorHelper.new(name)
        @integration_spec_helper = IntegrationSpecGeneratorHelper.new(name, options)
        @descriptor_spec_helper = SpecDescriptorGeneratorHelper.new(name)
        @policy_spec_helper = PolicySpecGeneratorHelper.new(name, options)
        @serializer_spec_helper = SerializerSpecGeneratorHelper.new(name)
      end

      def run_generators
        required_generators.each do |generator_name|
          generator_helper = instance_variable_get("@#{generator_name}_helper")
          puts "No generator called #{generator_name} can be found" if generator_helper.nil?

          if ['services', 'services_specs'].include?(generator_name)
            create_services(generator_helper)
          else
            template(
              generator_helper.template_path,
              generator_helper.class_file_path
            )
          end
        end
      end

      def add_routes
        route_string = mc_wrap_route_with_namespaces(@controller_helper.namespace) do
          actions = @controller_helper
            .actions
            .map { |attr| ":#{attr}" }
            .join(", ")

          "resources :#{@controller_helper.resource_name_plural}, only: [#{actions}]"
        end

        route route_string
      end

      private

      def required_generators
        [
          'controller',
          'policy',
          'serializer',
          'services',
          'descriptor_spec',
          'integration_spec',
          'policy_spec',
          'services_specs',
          'serializer_spec'
        ].tap do |default_generators|
          if options[:except].present?
            default_generators.reject! { |g| options[:except].include?(g) }
          elsif  options[:only].present?
            default_generators.select! { |g| options[:only].include?(g) }
          end
        end
      end

      def create_services(helper)
        helper.supported_actions(@controller_helper.actions).each do |action|
          template(
            helper.template_path(action),
            helper.class_file_name(action)
          )
        end
      end

    end
  end
end
