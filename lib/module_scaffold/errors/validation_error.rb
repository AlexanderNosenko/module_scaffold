# frozen_string_literal: true

module ModuleScaffold
  module Errors
    class ValidationError < BaseError
      code :unprocessable_entity
      http_code 422
      title 'Record is invalid'
    end
  end
end
