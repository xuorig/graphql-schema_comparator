module GraphQL
  module SchemaComparator
    module Changes
      # Breaking Changes

      class TypeRemoved
        attr_reader :removed_type

        def initialize(removed_type)
          @removed_type = removed_type
        end

        def message
          "#{removed_type.name} was removed"
        end
      end

      class DirectiveRemoved
        attr_reader :removed_directive

        def initialize(removed_directive)
          @removed_directive = removed_directive
        end

        def message
          "#{removed_directive.name} was removed"
        end
      end

      class TypeKindChanged
        attr_reader :old_type, :new_type

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
        end

        def message
          "`#{old_type.name}` kind changed from `#{old_type.kind}` to `#{new_type.kind}`"
        end
      end

      class EnumValueRemoved
        attr_reader :enum_value, :enum_type

        def initialize(enum_value, enum_type)
          @enum_value = enum_value
          @enum_type = enum_type
        end

        def message
          "Enum Value #{enum_value.name} was removed from Enum #{enum_type.name}"
        end
      end

      class UnionMemberRemoved
        attr_reader :union_type, :union_member

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
        end

        def message
          "Union member `#{union_member.name}` was removed from Union type `#{union_type.name}`"
        end
      end

      class InputFieldRemoved
        attr_reader :input_object_type, :field

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
        end

        def message
          "Input field `#{field.name}` was removed from input object type `#{input_object_type.name}`"
        end
      end

      class ObjectTypeArgumentRemoved
        attr_reader :object_type, :field, :argument

        def initialize(object_type, field, argument)
          @object_type = object_type
          @field = field
          @argument = argument
        end

        def message
          "Argument `#{argument.name}` was removed from field `#{object_type.name}.#{field.name}`"
        end
      end

      # TODO
      # class DirectiveArgumentRemoved
      # end

      # TODO
      # class SchemaQueryTypeChanged
      # end

      class FieldRemoved
        class InputFieldRemoved
          attr_reader :object_type, :field

          def initialize(object_type, field)
            @object_type = input_object_type
            @field = field
          end

          def message
            "Field `#{field.name}` was removed from object type #{object_type.name}"
          end
        end
      end

      # TODO
      # class DirectiveLocationRemoved
      # end

      class ObjectTypeInterfaceRemoved
        attr_reader :interface, :object_type

        def initialize(interface, object_type)
          @interface = interface
          @object_type = object_type
        end

        def message
          "`#{object_type.name}` object type no longer implements `#{interface.name}` interface"
        end
      end

      # Non-Breaking Changes

      class TypeAdded
        attr_reader :type

        def initialize(type)
          @type = type
        end

        def message
          "`#{type.name}` was added"
        end
      end

      class DirectiveAdded
        def initialize(*)
        end
      end

      class TypeDescriptionChanged
        attr_reader :old_type, :new_type

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
        end

        def message
          "Description `#{old_type.description}` on type `#{old_type.name}` has changed to `#{new_type.description}`"
        end
      end

      class EnumValueAdded
        attr_reader :enum_type, :enum_value

        def initialize(enum_type, enum_value)
          @enum_type = enum_type
          @enum_value = enum_value
        end

        def message
          "Enum value #{enum_value.name} was added on enum type #{enum_type.name}"
        end
      end

      class EnumValueDescriptionChanged
        def initialize(*)
        end
      end

      class EnumValueDeprecated
        def initialize(*)
        end
      end

      class UnionMemberAdded
        attr_reader :union_type, :union_member

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
        end

        def message
          "Union member `#{union_member.name}` was added to Union type `#{union_type.name}`"
        end
      end

      class InputFieldDescriptionChanged
        attr_reader :input_type, :old_field, :new_field

        def initialize(input_type, old_field, new_field)
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Input field `#{input_type.name}.#{old_field.name}` description changed"\
            " from `#{old_field.description}` to `#{new_field.description}`"
        end
      end

      class DirectiveDescriptionChanged
        def initialize(*)
        end
      end

      class FieldDescriptionChanged
        def initialize(*)
        end
      end

      class ObjectTypeArgumentDescriptionChanged
        def initialize(*)
        end
      end

      class DirectiveArgumentDescriptionChanged
        def initialize(*)
        end
      end

      class FieldDeprecationChanged
        def initialize(*)
        end
      end

      class InputFieldDefaultChanged
        attr_reader :input_type, :old_field, :new_field

        def initialize(input_type, old_field, new_field)
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Input field `#{input_type.name}.#{old_field.name}` default changed"\
            " from `#{old_field.default_value}` to `#{new_field.default_value}`"
        end
      end

      class ObjectTypeArgumentDefaultChanged
        def initialize(*)
        end
      end

      class DirectiveArgumentDefaultChanged
        def initialize(*)
        end
      end

      class ObjectTypeInterfaceAdded
        def initialize(*)
        end
      end

      class FieldAdded
        def initialize(*)
        end
      end

      class DirectiveLocationAdded
        def initialize(*)
        end
      end

      class FieldAstDirectiveAdded
        def initialize(*)
        end
      end

      class FieldAstDirectiveRemoved
        def initialize(*)
        end
      end

      class EnumValueAstDirectiveAdded
        def initialize(*)
        end
      end

      class EnumValueAstDirectiveRemoved
        def initialize(*)
        end
      end

      class InputFieldAstDirectiveAdded
        def initialize(*)
        end
      end

      class InputFieldAstDirectiveRemoved
        def initialize(*)
        end
      end

      class DirectiveArgumentAstDirectiveAdded
        def initialize(*)
        end
      end

      class DirectiveArgumentAstDirectiveRemoved
        def initialize(*)
        end
      end

      class FieldArgumentAstDirectiveAdded
        def initialize(*)
        end
      end

      class FieldArgumentAstDirectiveRemoved
        def initialize(*)
        end
      end

      class ObjectTypeAstDirectiveAdded
        def initialize(*)
        end
      end

      class ObjectTypeAstDirectiveRemoved
        def initialize(*)
        end
      end

      class InterfaceTypeAstDirectiveAdded
        def initialize(*)
        end
      end

      class InterfaceTypeAstDirectiveRemoved
        def initialize(*)
        end
      end

      class UnionTypeAstDirectiveAdded
        def initialize(*)
        end
      end

      class UnionTypeAstDirectiveRemoved
        def initialize(*)
        end
      end

      class EnumTypeAstDirectiveAdded
        def initialize(*)
        end
      end

      class EnumTypeAstDirectiveRemoved
        def initialize(*)
        end
      end

      class ScalarTypeAstDirectiveAdded
        def initialize(*)
        end
      end

      class ScalarTypeAstDirectiveRemoved
        def initialize(*)
        end
      end

      class InputObjectTypeAstDirectiveAdded
        def initialize(*)
        end
      end

      class InputObjectTypeAstDirectiveRemoved
        def initialize(*)
        end
      end

      class SchemaAstDirectiveAdded
        def initialize(*)
        end
      end

      class SchemaAstDirectiveRemoved
        def initialize(*)
        end
      end

      # Maybe Breaking

      class InputFieldAdded
        attr_reader :input_object_type, :field

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
        end

        def message
          "Input field `#{field.name}` was added to input object type `#{input_object_type.name}`"
        end
      end

      class ObjectTypeArgumentAdded
        def initialize(*)
        end
      end

      class DirectiveArgumentAdded
        def initialize(*)
        end
      end

      class InputFieldTypeChanged
        attr_reader :input_type, :old_input_field, :new_input_field

        def initialize(input_type, old_input_field, new_input_field)
          @input_type = input_type
          @old_input_field = old_input_field
          @new_input_field = new_input_field
        end

        def message
          "Input field `#{input_type}.#{old_input_field.name}` changed type from #{old_input_field.type} to #{new_input_field.type}"
        end
      end

      class ObjectTypeArgumentTypeChanged
        def initialize(*)
        end
      end

      class DirectiveArgumentTypeChanged
        def initialize(*)
        end
      end

      class FieldTypeChanged
        def initialize(*)
        end
      end

      class SchemaMutationTypeChanged
        def initialize(*)
        end
      end

      class SchemaSubscriptionTypeChanged
        def initialize(*)
        end
      end
    end
  end
end
