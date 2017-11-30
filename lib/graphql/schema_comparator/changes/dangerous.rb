module GraphQL
  module SchemaComparator
    module Changes
      class FieldArgumentDefaultChanged < AbstractChange
        attr_reader :type, :field, :old_argument, :new_argument, :criticality

        def initialize(type, field, old_argument, new_argument)
          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
          @criticality = Changes::Criticality.dangerous(
            reason: "Changing the default value for an argument may change the runtime " \
              "behaviour of a field if it was never provided."
          )
        end

        def message
          "Default value for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class EnumValueAdded < AbstractChange
        attr_reader :enum_type, :enum_value, :criticality

        def initialize(enum_type, enum_value)
          @enum_type = enum_type
          @enum_value = enum_value
          @criticality = Changes::Criticality.dangerous(
            reason: "Adding an enum value may break existing clients that were not " \
              "programming defensively against an added case when querying an enum."
          )
        end

        def message
          "Enum value `#{enum_value.name}` was added to enum `#{enum_type.name}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class UnionMemberAdded < AbstractChange
        attr_reader :union_type, :union_member, :criticality

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
          @criticality = Changes::Criticality.dangerous(
            reason: "Adding a possible type to Unions may break existing clients " \
              "that were not programming defensively against a new possible type."
          )
        end

        def message
          "Union member `#{union_member.name}` was added to Union type `#{union_type.name}`"
        end

        def breaking?
          !!@breaking
        end
      end
    end
  end
end
