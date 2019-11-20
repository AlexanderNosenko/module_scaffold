require_relative './concerns/generatable'
require_relative './concerns/spec_generatable'

class ServicesSpecsGeneratorHelper

  include Generatable
  include SpecGeneratable

  def template_path(version)
    "specs/services/#{version}.erb"
  end

  def class_file_path(version)
    File.join(
      files_dir,
      class_file_name(version)
    )
  end

  def class_name(action)
    "#{action.capitalize}#{module_name}"
  end

  def full_class_name(action)
    class_name = class_name(action)

    "#{module_full_name.pluralize}::#{class_name}"
  end

  def class_file_name(version)
    "#{class_name(version).underscore}_spec.rb"
  end

  def namespace_dirs
    namespace_modules(module_full_name)[0..-2] + [module_name.pluralize]
  end

  def versions
    controller_helper.actions & [:create, :update, :destroy]
  end

  def tested_attributes_formatted_str
    attributes = policy_helper.permitted_attributes - ['id', 'created_at', 'updated_at']

    attributes.map do |attr|
      "#{attr}: Faker::Name.first_name"
    end.join(",\n")
  end

  def permitted_attributes
    policy_helper.permitted_attributes
  end

  private

  def helper_type
    'Service'
  end

  def policy_helper
    @policy_helper ||= PolicyGeneratorHelper.new(module_full_name, options)
  end

  def controller_helper
    @controller_helper ||= ControllerGeneratorHelper.new(module_full_name, options)
  end

end
