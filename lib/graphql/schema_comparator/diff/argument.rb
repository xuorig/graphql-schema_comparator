module GraphQL
  module SchemaComparator
    module Diff
      class Argument
        def initialize(type, field, old_arg, new_arg)
          @type = type
          @field = field

          @old_arg = old_arg
          @new_arg = new_arg
        end

        def diff
          changes = []

          if old_arg.description != new_arg.description
            changes << Changes::FieldArgumentDescriptionChanged.new(type, field, old_arg, new_arg)
          end

          if old_arg.default_value != new_arg.default_value
            changes << Changes::FieldArgumentDefaultChanged.new(type, field, old_arg, new_arg)
          end

          if old_arg.type.to_type_signature != new_arg.type.to_type_signature
            changes << Changes::FieldArgumentTypeChanged.new(type, field, old_arg, new_arg)
          end

          # TODO directives

          changes
        end

        private

        attr_reader(
          :type,
          :field,
          :new_arg,
          :old_arg
        )
      end
    end
  end
end
