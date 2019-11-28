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

      def permitted_attributes(record, key: nil, allow_blank: false, authorization: nil)
        key =
          if key.present?
            key
          else
            implicit_param_key(record)
          end

        return {} if params[key].blank? && allow_blank

        # based on pundit/lib/pundit.rb
        policy = Pundit::PolicyFinder.new(record).policy!.new(authorization, record)

        params.require(key).permit(policy.permitted_attributes)
      end

      def implicit_param_key(record)
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
