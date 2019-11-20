require_relative './concerns/generatable'

class DescriptorSpecGeneratorHelper

  include Generatable

  def template_path(_)
    'specs/descriptor.erb'
  end

  def class_name
    "#{module_name}#{helper_type}"
  end

  def class_file_name(_)
    "#{resource_name}_#{helper_type.underscore}.rb"
  end

  def format_attr_str(attr)
    "#{attr}: { type: :string, 'x-nullable': true }"
  end

  def attributes
    policy_helper.permitted_attributes
  end

  private

  def helper_type
    'Descriptor'
  end

  def policy_helper
    @policy_helper ||= PolicyGeneratorHelper.new(module_full_name, options)
  end

end
