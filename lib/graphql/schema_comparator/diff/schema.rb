module GraphQL
  module SchemaComparator
    module Diff
      class Schema
        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema

          @old_types = old_schema.types
          @new_types = new_schema.types

          @old_directives = old_schema.directives
          @new_directives = new_schema.directives
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
            case old_type.kind.name
            when "ENUM"
              changes += Diff::Enum.new(old_type, new_type, enum_usage(new_type)).diff
            when "UNION"
              changes += Diff::Union.new(old_type, new_type).diff
            when "INPUT_OBJECT"
              changes += Diff::InputObject.new(old_type, new_type).diff
            when "OBJECT"
              changes += Diff::ObjectType.new(old_type, new_type).diff
            when "INTERFACE"
              changes += Diff::Interface.new(old_type, new_type).diff
            end
          end

          if old_type.description != new_type.description
            changes << Changes::TypeDescriptionChanged.new(old_type, new_type)
          end

          changes
        end

        def changes_in_schema
          changes = []

          if old_schema.query&.graphql_name != new_schema.query&.graphql_name
            if old_schema.query.nil?
              changes << Changes::RootOperationTypeAdded.new(new_schema: new_schema, operation_type: :query)
            elsif new_schema.query.nil?
              changes << Changes::RootOperationTypeRemoved.new(old_schema: old_schema, operation_type: :query)
            else
              changes << Changes::RootOperationTypeChanged.new(old_schema: old_schema, new_schema: new_schema, operation_type: :query)
            end
          end

          if old_schema.mutation&.graphql_name != new_schema.mutation&.graphql_name
            if old_schema.mutation.nil?
              changes << Changes::RootOperationTypeAdded.new(new_schema: new_schema, operation_type: :mutation)
            elsif new_schema.mutation.nil?
              changes << Changes::RootOperationTypeRemoved.new(old_schema: old_schema, operation_type: :mutation)
            else
              changes << Changes::RootOperationTypeChanged.new(old_schema: old_schema, new_schema: new_schema, operation_type: :mutation)
            end
          end

          if old_schema.subscription&.graphql_name != new_schema.subscription&.graphql_name
            if old_schema.subscription.nil?
              changes << Changes::RootOperationTypeAdded.new(new_schema: new_schema, operation_type: :subscription)
            elsif new_schema.subscription.nil?
              changes << Changes::RootOperationTypeRemoved.new(old_schema: old_schema, operation_type: :subscription)
            else
              changes << Changes::RootOperationTypeChanged.new(old_schema: old_schema, new_schema: new_schema, operation_type: :subscription)
            end
          end

          changes
        end

        def changes_in_directives
          changes = []

          changes += removed_directives.map { |directive| Changes::DirectiveRemoved.new(directive) }
          changes += added_directives.map { |directive| Changes::DirectiveAdded.new(directive) }

          each_common_directive do |old_directive, new_directive|
            changes += Diff::Directive.new(old_directive, new_directive).diff
          end

          changes
        end

        private

        def enum_usage(new_enum)
          input_usage = new_schema.references_to(new_enum).any? { |member| member.is_a?(GraphQL::Schema::Argument) }
          output_usage = new_schema.references_to(new_enum).any? { |member| member.is_a?(GraphQL::Schema::Field) }
          EnumUsage.new(input: input_usage, output: output_usage)
        end

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

        def removed_directives
          (old_directives.keys - new_directives.keys).map { |directive_name| old_schema.directives[directive_name] }
        end

        def added_directives
          (new_directives.keys - old_directives.keys).map { |directive_name| new_schema.directives[directive_name] }
        end

        def each_common_directive(&block)
          intersection = old_directives.keys & new_directives.keys
          intersection.each do |common_directive_name|
            old_directive = old_schema.directives[common_directive_name]
            new_directive = new_schema.directives[common_directive_name]

            block.call(old_directive, new_directive)
          end
        end

        attr_reader :old_schema, :new_schema, :old_types, :new_types, :old_directives, :new_directives
      end
    end
  end
end
