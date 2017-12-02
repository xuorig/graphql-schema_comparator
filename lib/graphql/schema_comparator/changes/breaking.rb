module GraphQL
  module SchemaComparator
    module Changes
      class TypeRemoved < AbstractChange
        attr_reader :removed_type, :criticality

        def initialize(removed_type)
          @removed_type = removed_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{removed_type.name}` was removed"
        end
      end

      class DirectiveRemoved < AbstractChange
        attr_reader :directive, :criticality

        def initialize(directive)
          @directive = directive
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{directive.name}` was removed"
        end
      end

      class TypeKindChanged < AbstractChange
        attr_reader :old_type, :new_type, :criticality

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{old_type.name}` kind changed from `#{old_type.kind}` to `#{new_type.kind}`"
        end
      end

      class EnumValueRemoved < AbstractChange
        attr_reader :enum_value, :enum_type, :criticality

        def initialize(enum_type, enum_value)
          @enum_value = enum_value
          @enum_type = enum_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Enum value `#{enum_value.name}` was removed from enum `#{enum_type.name}`"
        end
      end

      class UnionMemberRemoved < AbstractChange
        attr_reader :union_type, :union_member, :criticality

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Union member `#{union_member.name}` was removed from Union type `#{union_type.name}`"
        end
      end

      class InputFieldRemoved < AbstractChange
        attr_reader :input_object_type, :field, :criticality

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Input field `#{field.name}` was removed from input object type `#{input_object_type.name}`"
        end
      end

      class FieldArgumentRemoved < AbstractChange
        attr_reader :object_type, :field, :argument, :criticality

        def initialize(object_type, field, argument)
          @object_type = object_type
          @field = field
          @argument = argument
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Argument `#{argument.name}: #{argument.type}` was removed from field `#{object_type.name}.#{field.name}`"
        end
      end

      class DirectiveArgumentRemoved < AbstractChange
        attr_reader :directive, :argument, :criticality

        def initialize(directive, argument)
          @directive = directive
          @argument = argument
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Argument `#{argument.name}` was removed from directive `#{directive.name}`"
        end
      end

      class SchemaQueryTypeChanged < AbstractChange
        attr_reader :old_schema, :new_schema, :criticality

        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Schema query root has changed from `#{old_schema.query.name}` to `#{new_schema.query.name}`"
        end
      end

      class FieldRemoved < AbstractChange
        attr_reader :object_type, :field, :criticality

        def initialize(object_type, field)
          @object_type = object_type
          @field = field
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Field `#{field.name}` was removed from object type `#{object_type.name}`"
        end
      end

      class DirectiveLocationRemoved < AbstractChange
        attr_reader :directive, :location, :criticality

        def initialize(directive, location)
          @directive = directive
          @location = location
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Location `#{location}` was removed from directive `#{directive.name}`"
        end
      end

      class ObjectTypeInterfaceRemoved < AbstractChange
        attr_reader :interface, :object_type, :criticality

        def initialize(interface, object_type)
          @interface = interface
          @object_type = object_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{object_type.name}` object type no longer implements `#{interface.name}` interface"
        end
      end

      class FieldTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :type, :old_field, :new_field

        def initialize(type, old_field, new_field)
          @type = type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Field `#{type}.#{old_field.name}` changed type from `#{old_field.type}` to `#{new_field.type}`"
        end

        def criticality
          if safe_change_for_field?(old_field.type, new_field.type)
            Changes::Criticality.non_breaking
          else
            Changes::Criticality.breaking
          end
        end
      end

      class InputFieldTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :input_type, :old_input_field, :new_input_field, :criticality

        def initialize(input_type, old_input_field, new_input_field)
          if safe_change_for_input_value?(old_input_field.type, new_input_field.type)
            @criticality = Changes::Criticality.non_breaking(
              reason: "Changing an input field from non-null to null is considered non-breaking"
            )
          else
            @criticality = Changes::Criticality.breaking
          end

          @input_type = input_type
          @old_input_field = old_input_field
          @new_input_field = new_input_field
        end

        def message
          "Input field `#{input_type}.#{old_input_field.name}` changed type from `#{old_input_field.type}` to `#{new_input_field.type}`"
        end
      end

      class FieldArgumentTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :type, :field, :old_argument, :new_argument, :criticality

        def initialize(type, field, old_argument, new_argument)
          if safe_change_for_input_value?(old_argument.type, new_argument.type)
            @criticality = Changes::Criticality.non_breaking(
              reason: "Changing an input field from non-null to null is considered non-breaking"
            )
          else
            @criticality = Changes::Criticality.breaking
          end

          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Type for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.type}` to `#{new_argument.type}`"
        end
      end

      class DirectiveArgumentTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          if safe_change_for_input_value?(old_argument.type, new_argument.type)
            @criticality = Changes::Criticality.non_breaking(
              reason: "Changing an input field from non-null to null is considered non-breaking"
            )
          else
            @criticality = Changes::Criticality.breaking
          end

          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Type for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.type}` to `#{new_argument.type}`"
        end
      end

      class SchemaMutationTypeChanged < AbstractChange
        attr_reader :old_schema, :new_schema, :criticality

        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Schema mutation root has changed from `#{old_schema.mutation}` to `#{new_schema.mutation}`"
        end
      end

      class SchemaSubscriptionTypeChanged < AbstractChange
        attr_reader :old_schema, :new_schema, :criticality

        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Schema subscription type has changed from `#{old_schema.subscription}` to `#{new_schema.subscription}`"
        end
      end
    end
  end
end
