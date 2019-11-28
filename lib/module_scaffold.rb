# frozen_string_literal: true

require 'module_scaffold/version'
require 'module_scaffold/response_renderer'

require 'module_scaffold/errors/base_error'
require 'module_scaffold/errors/validation_error'

require 'module_scaffold/descriptors/rswag_descriptor'
require 'module_scaffold/descriptors/model_descriptor'

require 'module_scaffold/descriptors/errors/error_descriptor'
require 'module_scaffold/descriptors/errors/validation_error_descriptor'
require 'module_scaffold/descriptors/errors/record_not_found_error_descriptor'

require 'module_scaffold/spec_support/serializer_helpers'

require 'module_scaffold/serializers/errors/error_serializer'
require 'module_scaffold/serializers/errors/validation_error_serializer'

require 'module_scaffold/services/base_service'

module ModuleScaffold
end
