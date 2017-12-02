module GraphQL
  module SchemaComparator
    module Changes
      class TypeAdded < AbstractChange
        attr_reader :type, :criticality

        def initialize(type)
          @type = type
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Type `#{type.name}` was added"
        end
      end

      class DirectiveAdded < AbstractChange
        attr_reader :directive, :criticality

        def initialize(directive)
          @directive = directive
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Directive `#{directive.name}` was added"
        end
      end

      class TypeDescriptionChanged < AbstractChange
        attr_reader :old_type, :new_type, :criticality

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Description `#{old_type.description}` on type `#{old_type.name}` has changed to `#{new_type.description}`"
        end
      end

      class EnumValueDescriptionChanged < AbstractChange
        attr_reader :enum, :old_enum_value, :new_enum_value, :criticality

        def initialize(enum, old_enum_value, new_enum_value)
          @enum = enum
          @old_enum_value = old_enum_value
          @new_enum_value = new_enum_value
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Description for enum value `#{enum.name}.#{new_enum_value.name}` changed from " \
            "`#{old_enum_value.description}` to `#{new_enum_value.description}`"
        end
      end

      class EnumValueDeprecated < AbstractChange
        attr_reader :enum, :old_enum_value, :new_enum_value, :criticality

        def initialize(enum, old_enum_value, new_enum_value)
          @criticality = Changes::Criticality.non_breaking
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
      end

      class InputFieldDescriptionChanged < AbstractChange
        attr_reader :input_type, :old_field, :new_field, :criticality

        def initialize(input_type, old_field, new_field)
          @criticality = Changes::Criticality.non_breaking
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Input field `#{input_type.name}.#{old_field.name}` description changed"\
            " from `#{old_field.description}` to `#{new_field.description}`"
        end
      end

      class DirectiveDescriptionChanged < AbstractChange
        attr_reader :old_directive, :new_directive, :criticality

        def initialize(old_directive, new_directive)
          @criticality = Changes::Criticality.non_breaking
          @old_directive = old_directive
          @new_directive = new_directive
        end

        def message
          "Directive `#{new_directive.name}` description changed"\
            " from `#{old_directive.description}` to `#{new_directive.description}`"
        end
      end

      class FieldDescriptionChanged < AbstractChange
        attr_reader :type, :old_field, :new_field, :criticality

        def initialize(type, old_field, new_field)
          @criticality = Changes::Criticality.non_breaking
          @type = type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Field `#{type.name}.#{old_field.name}` description changed"\
            " from `#{old_field.description}` to `#{new_field.description}`"
        end
      end

      class FieldArgumentDescriptionChanged < AbstractChange
        attr_reader :type, :field, :old_argument, :new_argument, :criticality

        def initialize(type, field, old_argument, new_argument)
          @criticality = Changes::Criticality.non_breaking
          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Description for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end
      end

      class DirectiveArgumentDescriptionChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          @criticality = Changes::Criticality.non_breaking
          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Description for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end
      end

      class FieldDeprecationChanged < AbstractChange
        attr_reader :type, :old_field, :new_field, :criticality

        def initialize(type, old_field, new_field)
          @criticality = Changes::Criticality.non_breaking
          @type = type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Deprecation reason on field `#{type.name}.#{new_field.name}` has changed "\
            "from `#{old_field.deprecation_reason}` to `#{new_field.deprecation_reason}`"
        end
      end

      class InputFieldDefaultChanged < AbstractChange
        attr_reader :input_type, :old_field, :new_field, :criticality

        def initialize(input_type, old_field, new_field)
          @criticality = Changes::Criticality.non_breaking
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Input field `#{input_type.name}.#{old_field.name}` default changed"\
            " from `#{old_field.default_value}` to `#{new_field.default_value}`"
        end
      end

      class DirectiveArgumentDefaultChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          @criticality = Changes::Criticality.non_breaking
          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Default value for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
        end
      end

      class ObjectTypeInterfaceAdded < AbstractChange
        attr_reader :interface, :object_type, :criticality

        def initialize(interface, object_type)
          @criticality = Changes::Criticality.non_breaking
          @interface = interface
          @object_type = object_type
        end

        def message
          "`#{object_type.name}` object implements `#{interface.name}` interface"
        end
      end

      class FieldAdded < AbstractChange
        attr_reader :object_type, :field, :criticality

        def initialize(object_type, field)
          @criticality = Changes::Criticality.non_breaking
          @object_type = object_type
          @field = field
        end

        def message
          "Field `#{field.name}` was added to object type `#{object_type.name}`"
        end

      end

      class DirectiveLocationAdded < AbstractChange
        attr_reader :directive, :location, :criticality

        def initialize(directive, location)
          @criticality = Changes::Criticality.non_breaking
          @directive = directive
          @location = location
        end

        def message
          "Location `#{location}` was added to directive `#{directive.name}`"
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

      class DirectiveArgumentAdded < AbstractChange
        attr_reader :directive, :argument, :criticality

        def initialize(directive, argument)
          @criticality = Changes::Criticality.non_breaking
          @directive = directive
          @argument = argument
        end

        def message
          "Argument `#{argument.name}` was added to directive `#{directive.name}`"
        end
      end
    end
  end
end
