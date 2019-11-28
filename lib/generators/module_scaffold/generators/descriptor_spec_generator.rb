# frozen_string_literal: true

require_relative './concerns/generatable'

class DescriptorSpecGenerator
  include Generatable

  def template_path(_)
    'specs/descriptor.erb'
  end

  def class_file_name(_)
    "#{resource_name}_#{helper_type.underscore}.rb"
  end

  def class_name
    "#{module_name}#{helper_type}"
  end

  def full_class_name
    "#{module_full_name}#{helper_type}"
  end

  def generate_files(template_processor:, **)
    generate_file(self, template_processor)

    model_relationships_descriptor_generators.each do |generator|
      generate_file(generator, template_processor)
    end
  end

  def format_attr_str(attr)
    "#{attr}: { type: :string, 'x-nullable': true }"
  end

  def attributes
    policy_generator.permitted_attributes
  end

  def model_relationships_descriptor_generators
    model_relationships.map do |relationship|
      self.class.new(relationship.klass.name, options)
    end
  end

  private

  def model_relationships
    model_class.reflect_on_all_associations
  end

  def generate_file(generator, template_processor)
    template_processor.call(
      generator,
      generator.template_path(nil),
      generator.class_file_path(nil)
    )
  end

  def helper_type
    'Descriptor'
  end

  def policy_generator
    @policy_generator ||= PolicyGenerator.new(module_full_name, options)
  end
end
