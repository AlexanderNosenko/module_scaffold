require_relative './concerns/generatable'

class PolicyGeneratorHelper

  include Generatable

  def template_path(_)
    'policy.erb'
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

  def permitted_attributes
    model_class.new.attributes.keys
  end

  def permitted_attributes_formatted_str
    permitted_attributes.map do |attr|
      ":#{attr}"
    end.join(",\n")
  end

  def action_allowed?(action_name)
    controller_helper.actions.include?(action_name.to_sym).present?
  end

  private

  def helper_type
    'Policy'
  end

  def controller_helper
    @controller_helper ||= ControllerGeneratorHelper.new(module_full_name, options)
  end

end
