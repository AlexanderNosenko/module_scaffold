# frozen_string_literal: true

require_relative 'rswag_descriptor'

module ModuleScaffold
  module Descriptors
    class ModelDescriptor < RswagDescriptor
      def schema
        base_schema.tap do |schema|
          schema[:properties][:data] = if options[:collection]
                                         collection_schema(**options)
                                       else
                                         object_schema(**options)
                                       end

          if options[:included]
            schema[:properties][:included] = included_schema(options[:included])
          end

          if options[:with_total_count]
            schema[:properties][:meta] = {
              type: :object,
              properties: {
                total: { type: :integer }
              },
              required: ['total']
            }
          end
        end
      end

      private

      def base_schema
        {
          type: :object,
          properties: {
            data: {}
          },
          required: ['data']
        }
      end

      def object_schema(descriptor: nil, **options)
        descriptor ||= self.class

        {
          type: :object,
          properties: {
            id: { type: :string },
            type: { type: :string, enum: [descriptor.new.type] },
            attributes: descriptor_schema(descriptor)
          }
        }.tap do |schema|
          if options[:relationships].present?
            schema[:properties][:relationships] = {
              type: :object,
              properties: relationships_schema(options[:relationships])
            }
          end
        end
      end

      def collection_schema(descriptor: nil, **options)
        descriptor ||= self.class

        {
          type: :array,
          items: object_schema(descriptor: descriptor, **options)
        }
      end

      def included_schema(included)
        {
          type: :array,
          items: {
            anyOf: included.map(&method(:object_schema))
          }
        }
      end

      def descriptor_schema(descriptor)
        {
          type: :object,
          properties: camelize(descriptor.new.response_attributes)
        }
      end

      def relationship_descriptor_schema(descriptor_type)
        {
          type: :object,
          properties: {
            id: { type: :string },
            type: { type: :string, enum: [descriptor_type] }
          }
        }
      end

      def relationship_base_schema
        {
          type: :object,
          properties: {
            data: {}
          }
        }
      end

      def relationship_array_schema(descriptor)
        descriptor_type = descriptor.first.new.type

        rel_schema = relationship_base_schema.tap do |schema|
          schema[:properties][:data] = {
            type: :array,
            items: {
              anyOf: [relationship_descriptor_schema(descriptor_type)]
            }
          }
        end

        [descriptor_type.pluralize, rel_schema]
      end

      def relationships_schema(relationships)
        schema = relationships.map do |descriptor|
          if descriptor.is_a?(Array)
            relationship_array_schema(descriptor)
          else
            relationship_object_schema(descriptor)
          end
        end.to_h

        camelize(schema)
      end

      def relationship_object_schema(descriptor)
        descriptor_type = descriptor.new.type

        rel_schema = relationship_base_schema.tap do |schema|
          relation_schema = relationship_descriptor_schema(descriptor_type)
          relation_schema['x-nullable'] = true
          schema[:properties][:data] = relation_schema
        end

        [descriptor_type, rel_schema]
      end

      def camelize(attrs)
        attrs.deep_transform_keys { |key| key.to_s.camelize(:lower) }
      end
    end
  end
end
