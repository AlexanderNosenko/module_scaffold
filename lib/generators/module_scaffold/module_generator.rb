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

      class_option :controller_namespace, type: :string, default: '', desc: 'Controller namespace'
      class_option :controller_actions, type: :array, default: ControllerGeneratorHelper.new(nil).actions, desc: 'Desired controller actions'

      desc "Generates service oriented CRUD scaffold for an existing Model"

      include GeneratorHelpers

      def initialize_helpers
        name.constantize rescue raise "Model #{name} is not defined"

        @controller_helper = ControllerGeneratorHelper.new(name, options)
        @policy_helper = PolicyGeneratorHelper.new(name)
        @service_helper = ServiceGeneratorHelper.new(name, options)
        @serializer_helper = SerializerGeneratorHelper.new(name)
        @service_spec_helper = ServiceSpecGeneratorHelper.new(name)
        @integration_spec_helper = IntegrationSpecGeneratorHelper.new(name, options)
        @spec_descriptor_helper = SpecDescriptorGeneratorHelper.new(name)
        @policy_spec_helper = PolicySpecGeneratorHelper.new(name, options)
        @serializer_spec_helper = SerializerSpecGeneratorHelper.new(name)
      end

      def create_controller
        template(
          "controller.erb",
          File.join(
            @controller_helper.files_dir,
            @controller_helper.class_file_name
          )
        )
      end

      def create_policy
        template(
          "policy.erb",
          File.join(
            @policy_helper.files_dir,
            @policy_helper.class_file_name
          )
        )
      end

      def create_services
        @service_helper.supported_actions(@controller_helper.actions).each do |action|
          template(
            "services/#{action}.erb",
            File.join(
              @service_helper.files_dir,
              @service_helper.class_file_name(action)
            )
          )
        end
      end

      def create_serializer
        template(
          "serializer.erb",
          File.join(
            @serializer_helper.files_dir,
            @serializer_helper.class_file_name
          )
        )
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

      def create_service_specs
        @service_helper.supported_actions(@controller_helper.actions).each do |action|
          template(
            "specs/services/#{action}.erb",
            File.join(
              @service_spec_helper.files_dir,
              @service_spec_helper.class_file_name(action)
            )
          )
        end
      end

      def create_spec_descriptors
        template(
          "specs/descriptor.erb",
          File.join(
            @spec_descriptor_helper.files_dir,
            @spec_descriptor_helper.class_file_name
          )
        )
      end

      def create_integration_spec
        template(
          "specs/integration.erb",
          File.join(
            @integration_spec_helper.files_dir,
            @integration_spec_helper.class_file_name
          )
        )
      end

      def create_policy_spec
        template(
          "specs/policy.erb",
          File.join(
            @policy_spec_helper.files_dir,
            @policy_spec_helper.class_file_name
          )
        )
      end

      def create_serializer_spec
        template(
          "specs/serializer.erb",
          File.join(
            @serializer_spec_helper.files_dir,
            @serializer_spec_helper.class_file_name
          )
        )
      end

    end
  end
end
