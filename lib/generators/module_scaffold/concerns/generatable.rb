require 'active_support/concern'

module Generatable
  extend ActiveSupport::Concern

  attr_reader :module_full_name, :options

  def initialize(module_full_name, options = nil)
    @module_full_name = module_full_name
    @options = options
  end

  def class_file_path
    File.join(
      files_dir,
      class_file_name
    )
  end

  def model_class
    @model_class ||= module_full_name.constantize
  end

  def resource_name
    module_name.downcase
  end

  def module_name
    @module_name ||= namespace_modules(module_full_name).last
  end

  def resource_name_plural
    resource_name.pluralize
  end

  def files_dir
    directory_path = ['app', helper_type.downcase.pluralize]
    directory_path += namespace_dirs.map(&:downcase)
    directory_path.join('/')
  end

  def namespace_modules(namespace)
    if namespace.is_a?(Array)
      namespace
    else
      namespace.to_s.split('::')
    end
  end

  module_function :namespace_modules
end
