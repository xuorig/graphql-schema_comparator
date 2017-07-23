require "graphql/schema_comparator/diff/enum"
require "graphql/schema_comparator/diff/union"
require "graphql/schema_comparator/diff/input_object"
require "graphql/schema_comparator/diff/input_field"
require "graphql/schema_comparator/diff/object_type"
require "graphql/schema_comparator/diff/interface"
require "graphql/schema_comparator/diff/field"
require "graphql/schema_comparator/diff/argument"

module GraphQL
  module SchemaComparator
    module Diff
      class Schema
        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema

          @old_types = old_schema.types
          @new_types = new_schema.types
        end

        def diff
          changes = []

          # Removed and Added Types
          changes += removed_types.map { |type| Changes::TypeRemoved.new(type) }
          changes += added_types.map { |type| Changes::TypeAdded.new(type) }

          # Type Diff for common types
          each_common_type do |old_type, new_type|
            changes += changes_in_type(old_type, new_type)
          end

          # Diff Schemas
          changes += changes_in_schema

          # Diff Directives
          changes += changes_in_directives

          changes
        end

        def changes_in_type(old_type, new_type)
          changes = []

          if old_type.kind != new_type.kind
            changes << Changes::TypeKindChanged.new(old_type, new_type)
          else
            case old_type
            when GraphQL::EnumType
              changes += Diff::Enum.new(old_type, new_type).diff
            when GraphQL::UnionType
              changes += Diff::Union.new(old_type, new_type).diff
            when GraphQL::InputObjectType
              changes += Diff::InputObject.new(old_type, new_type).diff
            when GraphQL::ObjectType
              changes += Diff::ObjectType.new(old_type, new_type).diff
            when GraphQL::InterfaceType
              changes += Diff::Interface.new(old_type, new_type).diff
            end
          end

          if old_type.description != new_type.description
            changes << Changes::TypeDescriptionChanged.new(old_type, new_type)
          end

          changes
        end

        def changes_in_schema
          # TODO
          []
        end

        def changes_in_directives
          # TODO
          []
        end

        private

        def each_common_type(&block)
          intersection = old_types.keys & new_types.keys
          intersection.each do |common_type_name|
            old_type = old_schema.types[common_type_name]
            new_type = new_schema.types[common_type_name]

            block.call(old_type, new_type)
          end
        end

        def removed_types
          (old_types.keys - new_types.keys).map { |type_name| old_schema.types[type_name] }
        end

        def added_types
          (new_types.keys - old_types.keys).map { |type_name| new_schema.types[type_name] }
        end

        attr_reader :old_schema, :new_schema, :old_types, :new_types
      end
    end
  end
end
