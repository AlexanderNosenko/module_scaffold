require_relative './concerns/generatable'

class ControllerGeneratorHelper

  include Generatable

  def template_path
    'controller.erb'
  end

  def class_name
    "#{module_name.pluralize}#{helper_type}"
  end

  def class_file_name
    "#{resource_name_plural}_#{helper_type.underscore}.rb"
  end

  def namespace_dirs
    namespace_modules(namespace)
  end

  def namespace
    options[:'routes-namespace']
  end

  def actions
    @default_actions ||= [:index, :show, :create, :update, :destroy]
    return @default_actions if options.blank?

    options[:'controller-actions'].map(&:to_sym).presence || @default_actions
  end

  private

  def helper_type
    'Controller'
  end

end
