module GraphQL
  module SchemaComparator
    # Differ provides a list of changes given
    # two GraphQL::Schema instances.
    class Differ
      def initialize(old_schema, new_schema)
        @old_schema = old_schema
        @new_schema = new_schema
      end

      # Returns a list of Changes that happened
      # between old_schema and new_schema
      def changes
        changes = []

        # Type Removals and Additions
        old_types = old_schema.types
        new_types = new_schema.types

        removed = old_types.keys - new_types.keys
        added = new_types.keys - old_types.keys
        changes += removed.map { |type| Changes::TypeRemoved.new(type) }
        changes += added.map { |type| Changes::TypeAdded.new(type) }

        # Diffs from types
        intersection = old_types.keys & new_types.keys
        changes += intersection.flat_map { |type_name| changes_in_type(type_name) }

        # Diff Schemas
        changes += changes_in_schema

        # Diff Directives
        changes += changes_in_directives

        changes
      end

      def changes_in_type(type_name)
        old_type = old_schema.types[type_name]
        new_type = new_schema.types[type_name]

        changes = []

        if old_type.kind != new_type.kind
          changes << Changes::TypeKindChanged.new(old_type, new_type)
        else
          case old_type
          when EnumType
            changes += enum_type_changes(old_type, new_type)
          when UnionType
            changes += union_type_changes(old_type, new_type)
          when InputObjectType
            changes += input_object_type_changes(old_type, new_type)
          when ObjectType
            changes += object_type_changes(old_type, new_type)
          when InterfaceType
            changes += interface_type_changes(old_type, new_type)
          end
        end

        if old_type.description != new_type.description
          changes << Changes::TypeDescriptionChanged.new(old_type, new_type)
        end

        changes
      end

      def enum_type_changes(old_type, new_type)
        changes = []

        old_values = old_type.values
        new_values = new_type.values

        removed = old_values.keys - new_values.keys
        added = new_values.keys - old_values.keys

        changes += removed.map { |value| Changes::EnumValueRemoved.new(old_type, value) }
        changes += added.map { |value| Changes::EnumValueAdded.new(new_type, value) }

        (old_values.keys & new_values.keys).each do |common_value|
          # TODO: Add Directive Stuff

          old_value = old_type.values[common_value]
          new_value = new_type.values[common_value]

          if old_value.description != new_value.description
            changes += Changes::EnumValueDescriptionChanged.new(old_value, new_value)
          end

          if old_value.deprecation_reason != new_value.deprecation_reason
            changes += Changes::EnumValueDeprecated.new(old_value, new_value)
          end
        end

        changes
      end

      def union_type_changes(old_type, new_type)
        []
      end

      def input_object_type_changes(old_type, new_type)
        []
      end

      def object_type_changes(old_type, new_type)
        []
      end

      def interface_type_changes(old_type, new_type)
        []
      end

      def changes_in_schema
        # TODO
        []
      end

      def changes_in_directives
        # TODO
        []
      end

      attr_reader :old_schema, :new_schema
    end
  end
end
