module GraphQL
  module SchemaComparator
    module Diff
      class InputObject
        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type

          @old_fields = old_type.arguments
          @new_fields = new_type.arguments
        end

        def diff
          changes = []

          changes += removed_fields.map { |field| Changes::InputFieldRemoved.new(old_type, field) }
          changes += added_fields.map { |field| Changes::InputFieldAdded.new(new_type, field) }

          each_common_field do |old_field, new_field|
            # TODO: Add Directive Stuff
            changes += InputField.new(old_type, new_type, old_field, new_field).diff
          end

          changes
        end

        private

        attr_reader :old_type, :new_type, :old_fields, :new_fields

        def each_common_field(&block)
          intersection = old_fields.keys & new_fields.keys
          intersection.each do |common_field|
            old_field = old_type.arguments[common_field]
            new_field = new_type.arguments[common_field]

            block.call(old_field, new_field)
          end
        end

        def removed_fields
          old_fields.values.select { |field| !new_fields[field.graphql_name] }
        end

        def added_fields
          new_fields.values.select { |field| !old_fields[field.graphql_name] }
        end
      end
    end
  end
end
