# frozen_string_literal: true

require_relative './concerns/generatable'

class ControllerGenerator
  include Generatable

  def template_path(_)
    'controller.erb'
  end

  def class_file_name(_)
    "#{resource_name_plural}_#{helper_type.underscore}.rb"
  end

  def namespace_dirs
    namespace_modules(namespace)
  end

  def namespace
    options[:'routes-namespace']
  end

  def class_name
    "#{module_name.pluralize}#{helper_type}"
  end

  def actions
    @default_actions ||= %i[index show create update destroy]
    return @default_actions if options.blank?

    options[:'controller-actions'].map(&:to_sym).presence || @default_actions
  end

  def action_allowed?(action)
    actions.include?(action.to_sym).present?
  end

  def service_name(action)
    services_generator.full_class_name(action)
  end

  private

  def helper_type
    'Controller'
  end

  def services_generator
    @services_generator ||= ServicesGenerator.new(module_full_name, options)
  end
end
