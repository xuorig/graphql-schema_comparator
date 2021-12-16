module GraphQL
  module SchemaComparator
    module Diff
      class Field
        def initialize(old_type, new_type, old_field, new_field)
          @old_type = old_type
          @new_type = new_type

          @old_field = old_field
          @new_field = new_field

          @old_arguments = old_field.arguments
          @new_arguments = new_field.arguments
        end

        def diff
          changes = []

          if old_field.description != new_field.description
            changes << Changes::FieldDescriptionChanged.new(new_type, old_field, new_field)
          end

          if old_field.deprecation_reason != new_field.deprecation_reason
            changes << Changes::FieldDeprecationChanged.new(new_type, old_field, new_field)
          end

          if old_field.type.to_type_signature != new_field.type.to_type_signature
            changes << Changes::FieldTypeChanged.new(new_type, old_field, new_field)
          end

          changes += arg_removals

          changes += arg_additions

          each_common_argument do |old_arg, new_arg|
            changes += Diff::Argument.new(new_type, new_field, old_arg, new_arg).diff
          end

          changes
        end

        private

        attr_reader(
          :old_type,
          :new_type,
          :new_field,
          :old_field,
          :old_arguments,
          :new_arguments
        )

        def arg_removals
          removed = old_arguments.values.select { |arg| !new_arguments[arg.graphql_name] }
          removed.map { |arg| Changes::FieldArgumentRemoved.new(new_type, old_field, arg) }
        end

        def arg_additions
          removed = new_arguments.values.select { |arg| !old_arguments[arg.graphql_name] }
          removed.map { |arg| Changes::FieldArgumentAdded.new(new_type, new_field, arg) }
        end

        def each_common_argument(&block)
          intersection = old_arguments.keys & new_arguments.keys
          intersection.each do |common_arg|
            old_arg = old_field.arguments[common_arg]
            new_arg = new_field.arguments[common_arg]

            block.call(old_arg, new_arg)
          end
        end
      end
    end
  end
end
