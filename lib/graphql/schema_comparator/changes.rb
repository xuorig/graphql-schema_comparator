require 'graphql/schema_comparator/changes/criticality'
require 'graphql/schema_comparator/changes/breaking'
require 'graphql/schema_comparator/changes/dangerous'
require 'graphql/schema_comparator/changes/non_breaking'


module GraphQL
  module SchemaComparator
    module Changes
      module SafeTypeChange
        def safe_change_for_field?(old_type, new_type)
          if !old_type.kind.wraps? && !new_type.kind.wraps?
            old_type == new_type
          elsif new_type.kind.non_null?
            of_type = old_type.kind.non_null? ? old_type.of_type : old_type
            safe_change_for_field?(of_type, new_type.of_type)
          elsif old_type.kind.list?
            new_type.kind.list? && safe_change_for_field?(old_type.of_type, new_type.of_type) ||
              new_type.kind.non_null? && safe_change_for_field?(old_type, new_type.of_type)
          else
            false
          end
        end

        def safe_change_for_input_value?(old_type, new_type)
          if !old_type.kind.wraps? && !new_type.kind.wraps?
            old_type == new_type
          elsif old_type.kind.list? && new_type.kind.list?
            safe_change_for_input_value?(old_type.of_type, new_type.of_type)
          elsif old_type.kind.non_null?
            of_type = new_type.kind.non_null? ? new_type.of_type : new_type
            safe_change_for_input_value?(old_type.of_type, of_type)
          else
            false
          end
        end
      end

      class AbstractChange
        def message
          raise NotImplementedError
        end

        def breaking?
          raise NotImplementedError
        end

<<<<<<< HEAD
        def criticality
          raise NotImplementedError
=======
        def message
          "Description for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldDeprecationChanged < AbstractChange
        attr_reader :type, :old_field, :new_field

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
        attr_reader :input_type, :old_field, :new_field

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

      class FieldArgumentDefaultChanged < AbstractChange
        attr_reader :type, :field, :old_argument, :new_argument

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

        def breaking?
          !!@breaking
        end
      end

      class DirectiveArgumentDefaultChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument

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
        attr_reader :interface, :object_type

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
        attr_reader :object_type, :field

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
        attr_reader :directive, :location

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
        attr_reader :input_object_type, :field

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
        attr_reader :type, :field, :argument

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
        attr_reader :directive, :argument

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

        attr_reader :input_type, :old_input_field, :new_input_field

        def initialize(input_type, old_input_field, new_input_field)
          @input_type = input_type
          @old_input_field = old_input_field
          @new_input_field = new_input_field
          @breaking = !safe_change_for_input_value?(old_input_field.type, new_input_field.type)
        end

        def message
          "Input field `#{input_type}.#{old_input_field.name}` changed type from `#{old_input_field.type}` to `#{new_input_field.type}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class FieldArgumentTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :type, :field, :old_argument, :new_argument

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
        attr_reader :directive, :old_argument, :new_argument

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

      class FieldTypeChanged < AbstractChange
        include SafeTypeChange

        attr_reader :type, :old_field, :new_field

        def initialize(type, old_field, new_field)
          @type = type
          @old_field = old_field
          @new_field = new_field
          @breaking = !safe_change_for_field?(old_field.type, new_field.type)
        end

        def message
          "Field `#{type}.#{old_field.name}` changed type from `#{old_field.type}` to `#{new_field.type}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class SchemaMutationTypeChanged < AbstractChange
        attr_reader :old_schema, :new_schema

        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema
          @breaking = true
        end

        def message
          "Schema mutation root has changed from `#{old_schema.mutation}` to `#{new_schema.mutation}`"
        end

        def breaking?
          !!@breaking
        end
      end

      class SchemaSubscriptionTypeChanged < AbstractChange
        def initialize(old_schema, new_schema)
          @old_schema = old_schema
          @new_schema = new_schema
          @breaking = true
        end

        def message
          "Schema subscription type has changed from `#{old_schema.subscription}` to `#{new_schema.subscription}`"
        end

        def breaking?
          !!@breaking
>>>>>>> abf6fdc26bccad2be0368d6da0582f85cbf71278
        end
      end
    end
  end
end
