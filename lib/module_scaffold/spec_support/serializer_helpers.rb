# frozen_string_literal: true

module ModuleScaffold
  module SpecSupport
    module SerializerHelpers
      def expect_correct_attributes(attributes)
        expect(subject[:attributes].keys.sort).to eq(
          Array.wrap(attributes).sort
        )
      end

      def expect_correct_relationships(relationships)
        if relationships.nil?
          expect(subject[:relationships]).to be_blank
        else
          expect(subject[:relationships].keys.sort).to eq(
            Array.wrap(relationships).sort
          )
        end
      end

      def expect_correct_type(type)
        expect(subject[:type]).to eq type
      end

      def find_included_relation(included, type:)
        described_class.new(resource, params: params, include: [included])
                       .serializable_hash[:included]
                       .find { |relation| relation[:type] == type }
      end
    end
  end
end
