require 'active_support/concern'

module Generatable
  extend ActiveSupport::Concern

  attr_reader :module_full_name, :options

  def initialize(module_full_name, options = nil)
    @module_full_name = module_full_name
    @options = options
  end

  def class_file_path(version = nil)
    File.join(
      files_dir,
      class_file_name(version)
    )
  end

  def model_class
    @model_class ||= module_full_name.constantize
  end

  def resource_name
    module_name.underscore
  end

  def module_name
    @module_name ||= namespace_modules(module_full_name).last
  end

  def resource_name_plural
    resource_name.pluralize
  end

  def files_dir
    directory_path = ['app', helper_type.underscore.pluralize]
    directory_path += namespace_dirs.map(&:underscore)
    directory_path.join('/')
  end

  def namespace_dirs
    namespace_modules(module_full_name)[0..-2]
  end

  def namespace_modules(namespace)
    if namespace.is_a?(Array)
      namespace
    else
      namespace.to_s.split('::')
    end
  end

  def versions
    [
      'default'
    ]
  end

  def generate_files(template_processor:, **)
    versions.map do |version|
      template_processor.call(
        self,
        template_path(version),
        class_file_path(version)
      )
    end
  end

  module_function :namespace_modules
end
