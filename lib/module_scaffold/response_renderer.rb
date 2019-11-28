# frozen_string_literal: true

module ModuleScaffold
  module ResponseRenderer
    private

    def render_service(service)
      if service.success?
        render_success(service.result)
      else
        render_error(service.error)
      end
    end

    def render_success(response_data)
      return head :ok if response_data.nil?

      serialized_response = serialize_successful_response(response_data)

      render_response(serialized_response)
    end

    def render_error(error)
      serialized_response = serialize_failed_response(error)

      render_response(serialized_response, http_code: error.http_code)
    end

    def serialize_successful_response(response_data)
      serializer = find_serializer(response_data)

      if response_data.blank? || serializer.blank?
        {
          data: response_data
        }
      else
        serializer.new(response_data, is_collection: array_like?(response_data)).serialized_json
      end
    end

    def serialize_failed_response(error)
      serializer = find_serializer(error)

      if serializer.blank?
        {
          errors: Array.wrap(title: error.to_s)
        }
      else
        serializer.new(error).serialized_json
      end
    end

    def render_response(serialized_response, http_code: 200)
      render json: serialized_response, status: http_code
    end

    def find_serializer(response)
      class_name =
        if array_like?(response)
          response.first.class.name
        else
          response.class.name
        end

      prefix = response.is_a?(StandardError) ? 'Errors::' : nil

      begin
        "#{prefix}#{class_name}Serializer".constantize
      rescue StandardError
        nil
      end
    end

    def array_like?(response)
      response.respond_to?(:each) && !response.respond_to?(:keys)
    end
  end
end
