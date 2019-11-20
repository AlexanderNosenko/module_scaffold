# frozen_string_literal: true

require_relative './template_helpers'
require_relative './generators/controller_generator'
require_relative './generators/services_generator'
require_relative './generators/policy_generator'
require_relative './generators/serializer_generator'
require_relative './generators/services_specs_generator'
require_relative './generators/integration_spec_generator'
require_relative './generators/descriptor_spec_generator'
require_relative './generators/policy_spec_generator'
require_relative './generators/serializer_spec_generator'
require_relative './generators/routes_generator'

class ModuleScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :'routes-namespace', type: :string, default: '', desc: 'Routes namespace'
  class_option :'controller-actions', type: :array, default: ControllerGenerator.new(nil).actions, desc: 'Desired controller & service actions'
  class_option :only, type: :array, default: [], desc: 'Runs only specified generators'
  class_option :except, type: :array, default: [], desc: 'Does not run specified generators'
  class_option :'skip-routes', type: :boolean, default: false, desc: 'Skips route generation'

  desc 'Generates service oriented CRUD scaffold for an existing Model'

  include TemplateHelpers

  def ensure_module_exists
    begin
      name.constantize
    rescue StandardError
      raise "Model #{name} is not defined"
    end
  end

  def run_generators
    required_generators.each do |generator_name|
      initialize_generator(generator_name).generate_files(
        template_processor: proc { |*args| template(*args) },
        routes_processor: proc { |*args| route(*args) }
      )
    end
  end

  private

  def required_generators
    %w[
      controller
      policy
      serializer
      services
      descriptor_spec
      integration_spec
      policy_spec
      services_specs
      serializer_spec
    ].tap do |default_generators|
      if options[:except].present?
        default_generators.reject! { |g| options[:except].include?(g) }
      elsif  options[:only].present?
        default_generators.select! { |g| options[:only].include?(g) }
      end

      default_generators.push('routes') unless options[:'skip-routes']
    end
  end

  def initialize_generator(generator_name)
    @generator = "#{generator_name.camelize}Generator".constantize.new(name, options)
  end
end
