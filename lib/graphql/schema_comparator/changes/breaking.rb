module GraphQL
  module SchemaComparator
    module Changes
      class TypeRemoved < AbstractChange
        attr_reader :removed_type, :criticality

        def initialize(removed_type)
          @removed_type = removed_type
          @criticality = Changes::Criticality.breaking
        end

        def breaking?
          criticality.breaking?
        end

        def message
          "`#{removed_type.name}` was removed"
        end
      end

      class DirectiveRemoved < AbstractChange
        attr_reader :directive, :criticality

        def initialize(directive)
          @directive = directive
          @breaking = true
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{directive.name}` was removed"
        end

        def breaking?
          criticality.breaking?
        end
      end

      class TypeKindChanged < AbstractChange
        attr_reader :old_type, :new_type, :criticality

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @breaking = true
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{old_type.name}` kind changed from `#{old_type.kind}` to `#{new_type.kind}`"
        end

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
        end
      end

      class FieldTypeChanged < AbstractChange
        attr_reader :type, :old_field, :new_field, :criticality

        def initialize(type, old_field, new_field)
          @type = type
          @old_field = old_field
          @new_field = new_field
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Field `#{type}.#{old_field.name}` changed type from `#{old_field.type}` to `#{new_field.type}`"
        end

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
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

        def breaking?
          criticality.breaking?
        end
      end
    end
  end
end
