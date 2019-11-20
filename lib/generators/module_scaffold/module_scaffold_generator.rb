# frozen_string_literal: true

require_relative './helpers/generator_helpers'
require_relative './helpers/controller_generator_helper'
require_relative './helpers/services_generator_helper'
require_relative './helpers/policy_generator_helper'
require_relative './helpers/serializer_generator_helper'
require_relative './helpers/services_specs_generator_helper'
require_relative './helpers/integration_spec_generator_helper'
require_relative './helpers/descriptor_spec_generator_helper'
require_relative './helpers/policy_spec_generator_helper'
require_relative './helpers/serializer_spec_generator_helper'
require_relative './helpers/routes_generator_helper'

class ModuleScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  class_option :'routes-namespace', type: :string, default: '', desc: 'Routes namespace'
  class_option :'controller-actions', type: :array, default: ControllerGeneratorHelper.new(nil).actions, desc: 'Desired controller & service actions'
  class_option :only, type: :array, default: [], desc: 'Runs only specified generators'
  class_option :except, type: :array, default: [], desc: 'Does not run specified generators'
  class_option :'skip-routes', type: :boolean, default: false, desc: 'Skips route generation'

  desc 'Generates service oriented CRUD scaffold for an existing Model'

  include GeneratorHelpers

  def ensure_module_exists
    begin
      name.constantize
    rescue StandardError
      raise "Model #{name} is not defined"
    end
  end

  def run_generators
    required_generators.each do |generator_name|
      initialize_helper(generator_name).generate_files(
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

  def initialize_helper(generator_name)
    helper = "#{generator_name.camelize}GeneratorHelper".constantize.new(name, options)
    instance_variable_set('@helper', helper)
  end
end
