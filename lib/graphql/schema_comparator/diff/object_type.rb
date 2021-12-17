module GraphQL
  module SchemaComparator
    module Diff
      class ObjectType
        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type

          @old_fields = old_type.fields
          @new_fields = new_type.fields

          @old_interfaces = old_type.interfaces
          @new_interfaces = new_type.interfaces
        end

        def diff
          changes = []

          changes += interface_additions
          changes += interface_removals
          changes += field_removals
          changes += field_additions

          each_common_field do |old_field, new_field|
            changes += Diff::Field.new(old_type, new_type, old_field, new_field).diff
          end

          changes
        end

        private

        attr_reader(
          :old_type,
          :new_type,
          :old_fields,
          :new_fields,
          :old_interfaces,
          :new_interfaces
        )

        def interface_removals
          removed = filter_interfaces(old_interfaces, new_interfaces)
          removed.map { |interface| Changes::ObjectTypeInterfaceRemoved.new(interface, old_type) }
        end

        def interface_additions
          added = filter_interfaces(new_interfaces, old_interfaces)
          added.map { |interface| Changes::ObjectTypeInterfaceAdded.new(interface, new_type) }
        end

        def filter_interfaces(interfaces, excluded_interfaces)
          interfaces.select { |interface| !excluded_interfaces.map(&:graphql_name).include?(interface.graphql_name) }
        end

        def field_removals
          removed = old_fields.values.select { |field| !new_fields[field.graphql_name] }
          removed.map { |field| Changes::FieldRemoved.new(old_type, field) }
        end

        def field_additions
          added = new_fields.values.select { |field| !old_fields[field.graphql_name] }
          added.map { |field| Changes::FieldAdded.new(new_type, field) }
        end

        def each_common_field(&block)
          intersection = old_fields.keys & new_fields.keys
          intersection.each do |common_field|
            old_field = old_type.fields[common_field]
            new_field = new_type.fields[common_field]

            block.call(old_field, new_field)
          end
        end
      end
    end
  end
end
