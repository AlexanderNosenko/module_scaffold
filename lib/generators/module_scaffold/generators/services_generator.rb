# frozen_string_literal: true

require_relative './concerns/generatable'

class ServicesGenerator
  include Generatable

  def template_path(version)
    "services/#{version}.erb"
  end

  def class_name(action)
    "#{action.capitalize}#{module_name}"
  end

  def full_class_name(action)
    class_name = class_name(action)

    "#{module_full_name.pluralize}::#{class_name}"
  end

  def class_file_name(version)
    "#{class_name(version).underscore}.rb"
  end

  def namespace_dirs
    namespace_modules(module_full_name)[0..-2] + [module_name.pluralize]
  end

  def versions
    controller_generator.actions & %i[create update destroy]
  end

  private

  def helper_type
    'Service'
  end

  def controller_generator
    @controller_generator ||= ControllerGenerator.new(module_full_name, options)
  end
end
