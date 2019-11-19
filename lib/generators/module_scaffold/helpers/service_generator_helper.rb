require_relative './concerns/generatable'

class ServiceGeneratorHelper

  include Generatable

  def template_path(version)
    "services/#{version}.erb"
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
    "#{class_name(version).underscore}.rb"
  end

  def namespace_dirs
    namespace_modules(module_full_name)[0..-2] + [module_name.pluralize]
  end

  def versions
    @controller_helper = ControllerGeneratorHelper.new(module_full_name, options)

    @controller_helper.actions & [:create, :update, :destroy]
  end

  private

  def helper_type
    'Service'
  end

end
