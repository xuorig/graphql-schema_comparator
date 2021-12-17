module GraphQL
  module SchemaComparator
    module Diff
      class InputField
        def initialize(old_type, new_type, old_field, new_field)
          @old_type = old_type
          @new_type = new_type

          @old_field = old_field
          @new_field = new_field
        end

        def diff
          changes = []

          if old_field.description != new_field.description
            changes << Changes::InputFieldDescriptionChanged.new(old_type, old_field, new_field)
          end

          if old_field.default_value != new_field.default_value
            changes << Changes::InputFieldDefaultChanged.new(old_type, old_field, new_field)
          end

          if old_field.type.to_type_signature != new_field.type.to_type_signature
            changes << Changes::InputFieldTypeChanged.new(old_type, old_field, new_field)
          end

          # TODO: directives

          changes
        end

        private

        attr_reader :old_type, :new_type, :new_field, :old_field
      end
    end
  end
end
