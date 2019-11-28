# frozen_string_literal: true

require_relative './concerns/generatable'

class SerializerGenerator
  include Generatable

  def template_path(_)
    'serializer.erb'
  end

  def class_name
    "#{module_name}#{helper_type}"
  end

  def class_file_name(_)
    "#{resource_name}_#{helper_type.underscore}.rb"
  end

  def permitted_attributes
    model_class.new.attributes.keys
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
