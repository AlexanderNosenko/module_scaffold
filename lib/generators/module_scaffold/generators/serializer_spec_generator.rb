# frozen_string_literal: true

require_relative './concerns/generatable'
require_relative './concerns/spec_generatable'

class SerializerSpecGenerator
  include Generatable
  include SpecGeneratable

  def template_path(_)
    'specs/serializer.erb'
  end

  def class_name
    "#{module_name}#{helper_type}"
  end

  def full_class_name
    "#{module_full_name}#{helper_type}"
  end

  def class_file_name(_)
    "#{resource_name}_#{helper_type.underscore}_spec.rb"
  end

  def permitted_attributes
    model_class.new.attributes.keys
  end

  def permitted_attributes_formatted_str
    serializer_generator.permitted_attributes_formatted_str
  end

  private

  def helper_type
    'Serializer'
  end

  def serializer_generator
    @serializer_generator ||= SerializerGenerator.new(module_full_name, options)
  end
end
