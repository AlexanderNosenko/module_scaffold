require_relative './concerns/generatable'

class SpecDescriptorGeneratorHelper

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

  def namespace_dirs
    namespace_modules(module_full_name)[0..-2]
  end

  def format_attr_str(attr)
    "#{attr}: { type: :string, 'x-nullable': true }"
  end

  private

  def helper_type
    'Descriptor'
  end

end
