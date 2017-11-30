module GraphQL
  module SchemaComparator
    module Changes
      class TypeAdded < AbstractChange
        attr_reader :type, :criticality

        def initialize(type)
          @type = type
          @breaking = false
        end

        def message
          "Type `#{type.name}` was added"
        end

        def breaking?
          !!@breaking
        end
      end

      class DirectiveAdded < AbstractChange
        attr_reader :directive, :criticality

        def initialize(directive)
          @directive = directive
          @breaking = false
        end

        def message
          "Directive `#{directive.name}` was added"
        end

        def breaking?
          !!@breaking
        end
      end

      class TypeDescriptionChanged < AbstractChange
        attr_reader :old_type, :new_type, :criticality

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @breaking = false
        end

        def message
          "Description `#{old_type.description}` on type `#{old_type.name}` has changed to `#{new_type.description}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class EnumValueDescriptionChanged < AbstractChange
        attr_reader :enum, :old_enum_value, :new_enum_value, :criticality

        def initialize(enum, old_enum_value, new_enum_value)
          @enum = enum
          @old_enum_value = old_enum_value
          @new_enum_value = new_enum_value
        end

        def message
          "Description for enum value `#{enum.name}.#{new_enum_value.name}` changed from " \
            "`#{old_enum_value.description}` to `#{new_enum_value.description}`"
        end

        def breaking?
          false
        end
      end

      class EnumValueDeprecated < AbstractChange
        attr_reader :enum, :old_enum_value, :new_enum_value, :criticality

        def initialize(enum, old_enum_value, new_enum_value)
          @enum = enum
          @old_enum_value = old_enum_value
          @new_enum_value = new_enum_value
        end

        def message
          if old_enum_value.deprecation_reason
            "Enum value `#{enum.name}.#{new_enum_value.name}` deprecation reason changed " \
              "from `#{old_enum_value.deprecation_reason}` to `#{new_enum_value.deprecation_reason}`"
          else
            "Enum value `#{enum.name}.#{new_enum_value.name}` was deprecated with reason" \
              " `#{new_enum_value.deprecation_reason}`"
          end
        end

        def breaking?
          false
        end
      end

      class InputFieldDescriptionChanged < AbstractChange
        attr_reader :input_type, :old_field, :new_field, :criticality

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

        def breaking?
          !!@breaking
        end
      end

      class DirectiveDescriptionChanged < AbstractChange
        attr_reader :old_directive, :new_directive, :criticality

        def initialize(old_directive, new_directive)
          @old_directive = old_directive
          @new_directive = new_directive
          @breaking = false
        end

        def message
          "Directive `#{new_directive.name}` description changed"\
            " from `#{old_directive.description}` to `#{new_directive.description}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldDescriptionChanged < AbstractChange
        attr_reader :type, :old_field, :new_field, :criticality

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

        def breaking?
          !!@breaking
        end
      end

      class FieldArgumentDescriptionChanged < AbstractChange
        attr_reader :type, :field, :old_argument, :new_argument, :criticality

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

        def breaking?
          !!@breaking
        end
      end

      class DirectiveArgumentDescriptionChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = false
        end

        def message
          "Description for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldDeprecationChanged < AbstractChange
        attr_reader :type, :old_field, :new_field, :criticality

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

        def breaking?
          !!@breaking
        end
      end

      class InputFieldDefaultChanged < AbstractChange
        attr_reader :input_type, :old_field, :new_field, :criticality

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

        def breaking?
          !!@breaking
        end
      end

      class DirectiveArgumentDefaultChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = false
        end

        def message
          "Default value for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class ObjectTypeInterfaceAdded < AbstractChange
        attr_reader :interface, :object_type, :criticality

        def initialize(interface, object_type)
          @interface = interface
          @object_type = object_type
          @breaking = false
        end

        def message
          "`#{object_type.name}` object implements `#{interface.name}` interface"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldAdded < AbstractChange
        attr_reader :object_type, :field, :criticality

        def initialize(object_type, field)
          @object_type = object_type
          @field = field
          @breaking = false
        end

        def message
          "Field `#{field.name}` was added to object type `#{object_type.name}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class DirectiveLocationAdded < AbstractChange
        attr_reader :directive, :location, :criticality

        def initialize(directive, location)
          @directive = directive
          @location = location
          @breaking = false
        end

        def message
          "Location `#{location}` was added to directive `#{directive.name}`"
        end

        def breaking?
          !!@breaking
        end
      end

      # TODO
      class FieldAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class FieldAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class EnumValueAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class EnumValueAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class InputFieldAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class InputFieldAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class DirectiveArgumentAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class DirectiveArgumentAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class FieldArgumentAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class FieldArgumentAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class ObjectTypeAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class ObjectTypeAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class InterfaceTypeAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class InterfaceTypeAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class UnionTypeAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class UnionTypeAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class EnumTypeAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class EnumTypeAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class ScalarTypeAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class ScalarTypeAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class InputObjectTypeAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class InputObjectTypeAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class SchemaAstDirectiveAdded < AbstractChange
        def initialize(*)
        end
      end

      # TODO
      class SchemaAstDirectiveRemoved < AbstractChange
        def initialize(*)
        end
      end

      class InputFieldAdded < AbstractChange
        attr_reader :input_object_type, :field, :criticality

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
          @breaking = field.type.kind.non_null? ? true : false
        end

        def message
          "Input field `#{field.name}` was added to input object type `#{input_object_type.name}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldArgumentAdded < AbstractChange
        attr_reader :type, :field, :argument, :criticality

        def initialize(type, field, argument)
          @type = type
          @field = field
          @argument = argument
          # TODO: should at least have a warning that it may still be breaking
          @breaking = argument.type.kind.non_null? ? true : false
        end

        def message
          "Argument `#{argument.name}: #{argument.type}` added to field `#{type.name}.#{field.name}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class DirectiveArgumentAdded < AbstractChange
        attr_reader :directive, :argument, :criticality

        def initialize(directive, argument)
          @directive = directive
          @argument = argument
          @breaking = false
        end

        def message
          "Argument `#{argument.name}` was added to directive `#{directive.name}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class InputFieldTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :input_type, :old_input_field, :new_input_field, :criticality

        def initialize(input_type, old_input_field, new_input_field)
          @input_type = input_type
          @old_input_field = old_input_field
          @new_input_field = new_input_field
          @breaking = !safe_change_for_input_value?(old_input_field.type, new_input_field.type)
        end

        def message
          "Input field `#{input_type}.#{old_input_field.name}` changed type from #{old_input_field.type} to #{new_input_field.type}"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldArgumentTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :type, :field, :old_argument, :new_argument, :criticality

        def initialize(type, field, old_argument, new_argument)
          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = !safe_change_for_input_value?(old_argument.type, new_argument.type)
        end

        def message
          "Type for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.type}` to `#{new_argument.type}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class DirectiveArgumentTypeChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
          @breaking = false
        end

        def message
          "Type for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.type}` to `#{new_argument.type}`"
        end

        def breaking?
          !!@breaking
        end
      end
    end
  end
end
