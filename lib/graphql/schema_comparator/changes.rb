module GraphQL
  module SchemaComparator
    module Changes
      # Breaking Changes

      class TypeRemoved
        attr_reader :removed_type, :breaking

        def initialize(removed_type)
          @removed_type = removed_type
          @breaking = true
        end

        def message
          "#{removed_type.name} was removed"
        end
      end

      class DirectiveRemoved
        attr_reader :removed_directive, :breaking

        def initialize(removed_directive)
          @removed_directive = removed_directive
          @breaking = true
        end

        def message
          "#{removed_directive.name} was removed"
        end
      end

      class TypeKindChanged
        attr_reader :old_type, :new_type, :breaking

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @breaking = true
        end

        def message
          "`#{old_type.name}` kind changed from `#{old_type.kind}` to `#{new_type.kind}`"
        end
      end

      class EnumValueRemoved
        attr_reader :enum_value, :enum_type, :breaking

        def initialize(enum_value, enum_type)
          @enum_value = enum_value
          @enum_type = enum_type
          @breaking = true
        end

        def message
          "Enum Value #{enum_value.name} was removed from Enum #{enum_type.name}"
        end
      end

      class UnionMemberRemoved
        attr_reader :union_type, :union_member, :breaking

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
          @breaking = true
        end

        def message
          "Union member `#{union_member.name}` was removed from Union type `#{union_type.name}`"
        end
      end

      class InputFieldRemoved
        attr_reader :input_object_type, :field, :breaking

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
          @breaking = true
        end

        def message
          "Input field `#{field.name}` was removed from input object type `#{input_object_type.name}`"
        end
      end

      class FieldArgumentRemoved
        attr_reader :object_type, :field, :argument, :breaking

        def initialize(object_type, field, argument)
          @object_type = object_type
          @field = field
          @argument = argument
          @breaking = true
        end

        def message
          "Argument `#{argument.name}: #{argument.type}` was removed from field `#{object_type.name}.#{field.name}`"
        end
      end

      # TODO
      # class DirectiveArgumentRemoved
      # end

      # TODO
      # class SchemaQueryTypeChanged
      # end

      class FieldRemoved
        attr_reader :object_type, :field, :breaking

        def initialize(object_type, field)
          @object_type = object_type
          @field = field
          @breaking = true
        end

        def message
          "Field `#{field.name}` was removed from object type `#{object_type.name}`"
        end
      end

      # TODO
      # class DirectiveLocationRemoved
      # end

      class ObjectTypeInterfaceRemoved
        attr_reader :interface, :object_type, :breaking

        def initialize(interface, object_type)
          @interface = interface
          @object_type = object_type
          @breaking = true
        end

        def message
          "`#{object_type.name}` object type no longer implements `#{interface.name}` interface"
        end
      end

      # Non-Breaking Changes

      class TypeAdded
        attr_reader :type, :breaking

        def initialize(type)
          @type = type
          @breaking = false
        end

        def message
          "`#{type.name}` was added"
        end
      end

      class DirectiveAdded
        attr_reader :breaking

        def initialize(*)
          @breaking = false
        end
      end

      class TypeDescriptionChanged
        attr_reader :old_type, :new_type, :breaking

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @breaking = false
        end

        def message
          "Description `#{old_type.description}` on type `#{old_type.name}` has changed to `#{new_type.description}`"
        end
      end

      class EnumValueAdded
        attr_reader :enum_type, :enum_value, :breaking

        def initialize(enum_type, enum_value)
          @enum_type = enum_type
          @enum_value = enum_value
          @breaking = false
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
        attr_reader :union_type, :union_member, :breaking

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
          @breaking = false
        end

        def message
          "Union member `#{union_member.name}` was added to Union type `#{union_type.name}`"
        end
      end

      class InputFieldDescriptionChanged
        attr_reader :input_type, :old_field, :new_field, :breaking

        def initialize(input_type, old_field, new_field)
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
          @breaking = false
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
        attr_reader :type, :old_field, :new_field, :breaking

        def initialize(type, old_field, new_field)
          @type = type
          @old_field = old_field
          @new_field = new_field
          @breaking = false
        end

        def message
          "Field `#{type.name}.#{old_field.name}` description changed"\
            " from `#{old_field.description}` to `#{new_field.description}`"
        end
      end

      class FieldArgumentDescriptionChanged
        attr_reader :type, :field, :old_argument, :new_argument, :breaking

        def initialize(type, field, old_argument, new_argument)
          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = false
        end

        def message
          "Description for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end
      end

      class DirectiveArgumentDescriptionChanged
        def initialize(*)
        end
      end

      class FieldDeprecationChanged
        attr_reader :type, :old_field, :new_field, :breaking

        def initialize(type, old_field, new_field)
          @type = type
          @old_field = old_field
          @new_field = new_field
          @breaking = false
        end

        def message
          "Deprecation reason on field `#{type.name}.#{new_field.name}` has changed "\
            "from `#{old_field.deprecation_reason}` to `#{new_field.deprecation_reason}`"
        end
      end

      class InputFieldDefaultChanged
        attr_reader :input_type, :old_field, :new_field, :breaking

        def initialize(input_type, old_field, new_field)
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
          @breaking = false
        end

        def message
          "Input field `#{input_type.name}.#{old_field.name}` default changed"\
            " from `#{old_field.default_value}` to `#{new_field.default_value}`"
        end
      end

      class FieldArgumentDefaultChanged
        attr_reader :type, :field, :old_argument, :new_argument, :breaking

        def initialize(type, field, old_argument, new_argument)
          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = false
        end

        def message
          "Default value for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
        end
      end

      class DirectiveArgumentDefaultChanged
        def initialize(*)
        end
      end

      class ObjectTypeInterfaceAdded
        attr_reader :interface, :object_type, :breaking

        def initialize(interface, object_type)
          @interface = interface
          @object_type = object_type
          @breaking = false
        end

        def message
          "`#{object_type.name}` object implements `#{interface.name}` interface"
        end
      end

      class FieldAdded
        attr_reader :object_type, :field, :breaking

        def initialize(object_type, field)
          @object_type = object_type
          @field = field
          @breaking = false
        end

        def message
          "Field `#{field.name}` was added to object type `#{object_type.name}`"
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
        attr_reader :input_object_type, :field, :breaking

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
        end

        def message
          "Input field `#{field.name}` was added to input object type `#{input_object_type.name}`"
        end
      end

      class FieldArgumentAdded
        attr_reader :type, :field, :argument, :breaking

        def initialize(type, field, argument)
          @type = type
          @field = field
          @argument = argument
          @breaking = false
        end

        def message
          "Argument `#{argument.name}: #{argument.type}` added to field `#{type.name}.#{field.name}`"
        end
      end

      class DirectiveArgumentAdded
        def initialize(*)
        end
      end

      class InputFieldTypeChanged
        attr_reader :input_type, :old_input_field, :new_input_field, :breaking

        def initialize(input_type, old_input_field, new_input_field)
          @input_type = input_type
          @old_input_field = old_input_field
          @new_input_field = new_input_field
          @breaking = false
        end

        def message
          "Input field `#{input_type}.#{old_input_field.name}` changed type from #{old_input_field.type} to #{new_input_field.type}"
        end
      end

      class FieldArgumentTypeChanged
        attr_reader :type, :field, :old_argument, :new_argument, :breaking

        def initialize(type, field, old_argument, new_argument)
          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = false
        end

        def message
          "Type for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.type}` to `#{new_argument.type}`"
        end
      end

      class DirectiveArgumentTypeChanged
        def initialize(*)
        end
      end

      class FieldTypeChanged
        attr_reader :type, :old_field, :new_field, :breaking

        def initialize(type, old_field, new_field)
          @type = type
          @old_field = old_field
          @new_field = new_field
          @breaking = false
        end

        def message
          "Field `#{type}.#{old_field.name}` changed type from `#{old_field.type}` to `#{new_field.type}`"
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
