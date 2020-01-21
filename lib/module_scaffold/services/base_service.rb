# frozen_string_literal: true

module ModuleScaffold
  module Services
    class BaseService
      def call(*_args)
        self
      end

      def self.call(*args)
        new(*args).call
      end

      attr_reader :error, :result

      def success?
        result.present? && error.blank?
      end

      def failure?
        !success?
      end

      private

      attr_writer :error, :result

      def failure!(error)
        self.error = error
        raise(ServiceError, nil, error)
      end

      def failure(error)
        self.error = error
        self
      end

      def success(result)
        self.result = result
        self
      end

      def permitted_attributes(record, key: nil, session: nil, allow_blank: false)
        resolved_key = resolve_key(key, record)

        return {} if allow_blank && params[resolved_key].blank?

        policy = Pundit::PolicyFinder.new(record).policy!.new(session, record)
        params.require(resolved_key).permit(policy.permitted_attributes)
      end

      def resolve_key(key, record)
        return key if key.present?

        klass =
          if record.is_a? ApplicationRecord
            record.class
          else
            record
          end

        klass.name.split('::').last.underscore
      end

      class ServiceError < StandardError
        attr_reader :original_error

        def initialize(error, message: nil)
          super(message)
          @original_error = error
        end
      end
    end
  end
end
