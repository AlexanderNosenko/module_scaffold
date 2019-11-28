# frozen_string_literal: true

module SpecGeneratable
  def files_dir
    directory_path = ['spec', helper_type.underscore.pluralize]
    directory_path += namespace_dirs.map(&:underscore)
    directory_path.join('/')
  end
end
