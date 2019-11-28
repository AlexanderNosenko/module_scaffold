# frozen_string_literal: true

require_relative './concerns/generatable'
require_relative './concerns/spec_generatable'

class IntegrationSpecGenerator
  include Generatable
  include SpecGeneratable

  def template_path(_)
    'specs/integration.erb'
  end

  def class_name
    module_name.pluralize
  end

  def class_file_name(_)
    "#{class_name.underscore}_spec.rb"
  end

  def descriptor_class_name
    descriptor_generator.class_name
  end

  def index_route_str
    @controller_helper = ControllerGenerator.new(module_full_name, options)
    dirs = @controller_helper.namespace_dirs + [resource_name_plural]
    "/#{dirs.map(&:underscore).join('/')}"
  end

  def sample_attribute_name
    @sample_attribute_name ||= begin
      @policy_helper = PolicyGenerator.new(module_full_name)
      @policy_helper.permitted_attributes.sample
    end
  end

  def sample_param_reference
    "params[:#{resource_name}][:#{sample_attribute_name}]"
  end

  def route_id_param
    "#{resource_name}_id"
  end

  def tested_attributes
    services_specs_generator.tested_attributes_formatted_str
  end

  def relationship_descriptors_formatted_str
    descriptor_generator
      .model_relationships_descriptor_generators
      .map(&:full_class_name)
      .join(",\n")
  end

  private

  def helper_type
    'Integration'
  end

  def descriptor_generator
    @descriptor_generator ||= DescriptorSpecGenerator.new(module_full_name, options)
  end

  def services_specs_generator
    @services_specs_generator ||= ServicesSpecsGenerator.new(module_full_name, options)
  end
end
