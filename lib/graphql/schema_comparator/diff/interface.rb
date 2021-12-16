module GraphQL
  module SchemaComparator
    module Diff
      class Interface
        def initialize(old_interface, new_interface)
          @old_interface = old_interface
          @new_interface = new_interface

          @old_fields = old_interface.fields
          @new_fields = new_interface.fields
        end

        def diff
          changes = []
          changes += field_removals
          changes += field_additions

          each_common_field do |old_field, new_field|
            changes += Diff::Field.new(old_interface, new_interface, old_field, new_field).diff
          end

          changes
        end

        private

        attr_reader :old_interface, :new_interface, :old_fields, :new_fields

        def field_removals
          removed = old_fields.values.select { |field| !new_fields[field.graphql_name] }
          removed.map { |field| Changes::FieldRemoved.new(old_interface, field) }
        end

        def field_additions
          added = new_fields.values.select { |field| !old_fields[field.graphql_name] }
          added.map { |field| Changes::FieldAdded.new(new_interface, field) }
        end

        def each_common_field(&block)
          intersection = old_fields.keys & new_fields.keys
          intersection.each do |common_field|
            old_field = old_interface.fields[common_field]
            new_field = new_interface.fields[common_field]

            block.call(old_field, new_field)
          end
        end
      end
    end
  end
end
