require 'graphql/schema_comparator/changes/criticality'
require 'graphql/schema_comparator/changes/safe_type_change'

module GraphQL
  module SchemaComparator
    module Changes
      # Base class for change objects
      class AbstractChange
        # A message describing the change that happened between the two version
        # @return [String] The change message
        def message
          raise NotImplementedError
        end

        # @return [Boolean] If the change is breaking or not
        def breaking?
          criticality.breaking?
        end

        # @return [Boolean] If the change is dangerous or not
        def dangerous?
          criticality.dangerous?
        end

        # @return [Boolean] If the change is non breaking
        def non_breaking?
          criticality.non_breaking?
        end

        # @return [GraphQL::SchemaComparator::Changes::Criticality] The criticality of this change
        def criticality
          raise NotImplementedError
        end

        # @return [String] Dot-delimited path to the affected schema member.
        def path
          raise NotImplementedError
        end
      end

      # Mostly breaking changes

      class TypeRemoved < AbstractChange
        attr_reader :removed_type, :criticality

        def initialize(removed_type)
          @removed_type = removed_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "`#{removed_type.name}` was removed"
        end

        def path
          removed_type.name
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

        def path
          directive.name
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

        def path
          old_type.name
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

        def path
          [enum_type.name, enum_value.name].join('.')
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

        def path
          union_type.name
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

        def path
          [input_object_type.name, field.name].join('.')
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

        def path
          [object_type.name, field.name, argument.name].join('.')
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

        def path
          ["@#{directive.name}", argument.name].join('.')
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

        def path
          # TODO
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

        def path
          [object_type.name, field.name].join('.')
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

        def path
          "@#{directive.name}"
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

        def path
          object_type.name
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

        def path
          [type.name, old_field.name].join('.')
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

        def path
          [input_type.name, old_input_field.name].join('.')
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

        def path
          [type.name, field.name, old_argument.name].join('.')
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

        def path
          ["@#{directive.name}", old_argument.name].join('.')
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

        def path
          # TODO
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

        def path
          # TODO
        end
      end

      # Dangerous Changes

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
          if old_argument.default_value.nil?
            "Default value `#{new_argument.default_value}` was added to argument `#{new_argument.name}` on field `#{type.name}.#{field.name}`"
          else
            "Default value for argument `#{new_argument.name}` on field `#{type.name}.#{field.name}` changed"\
              " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
          end
        end

        def path
          [type.name, field.name, old_argument.name].join('.')
        end
      end

      class InputFieldDefaultChanged < AbstractChange
        attr_reader :input_type, :old_field, :new_field, :criticality

        def initialize(input_type, old_field, new_field)
          @criticality = Changes::Criticality.dangerous(
            reason: "Changing the default value for an argument may change the runtime " \
              "behaviour of a field if it was never provided."
          )
          @input_type = input_type
          @old_field = old_field
          @new_field = new_field
        end

        def message
          "Input field `#{input_type.name}.#{old_field.name}` default changed"\
            " from `#{old_field.default_value}` to `#{new_field.default_value}`"
        end

        def path
          [input_type.name, old_field.name].join(".")
        end
      end

      class DirectiveArgumentDefaultChanged < AbstractChange
        attr_reader :directive, :old_argument, :new_argument, :criticality

        def initialize(directive, old_argument, new_argument)
          @criticality = Changes::Criticality.dangerous(
            reason: "Changing the default value for an argument may change the runtime " \
              "behaviour of a field if it was never provided."
          )
          @directive = directive
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Default value for argument `#{new_argument.name}` on directive `#{directive.name}` changed"\
            " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
        end

        def path
          ["@#{directive.name}", new_argument.name].join(".")
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

        def path
          [enum_type.name, enum_value.name].join(".")
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

        def path
          union_type.name
        end
      end

      class ObjectTypeInterfaceAdded < AbstractChange
        attr_reader :interface, :object_type, :criticality

        def initialize(interface, object_type)
          @criticality = Changes::Criticality.dangerous(
            reason: "Adding an interface to an object type may break existing clients " \
              "that were not programming defensively against a new possible type."
          )
          @interface = interface
          @object_type = object_type
        end

        def message
          "`#{object_type.name}` object implements `#{interface.name}` interface"
        end

        def path
          object_type.name
        end
      end

      # Mostly Non-Breaking Changes

      class InputFieldAdded < AbstractChange
        attr_reader :input_object_type, :field, :criticality

        def initialize(input_object_type, field)
          @criticality = if field.type.non_null?
            Changes::Criticality.breaking
          else
            Changes::Criticality.non_breaking
          end

          @input_object_type = input_object_type
          @field = field
        end

        def message
          "Input field `#{field.name}` was added to input object type `#{input_object_type.name}`"
        end

        def path
          [input_object_type.name, field.name].join(".")
        end
      end

      class FieldArgumentAdded < AbstractChange
        attr_reader :type, :field, :argument, :criticality

        def initialize(type, field, argument)
          @criticality = if argument.type.non_null?
            Changes::Criticality.breaking
          else
            Changes::Criticality.non_breaking
          end

          @type = type
          @field = field
          @argument = argument
        end

        def message
          "Argument `#{argument.name}: #{argument.type}` added to field `#{type.name}.#{field.name}`"
        end

        def path
          [type.name, field.name, argument.name].join(".")
        end
      end

      class TypeAdded < AbstractChange
        attr_reader :type, :criticality

        def initialize(type)
          @type = type
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Type `#{type.name}` was added"
        end

        def path
          type.name
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

        def path
          "@#{directive.name}"
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

        def path
          old_type.name
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

        def path
          [enum.name, old_enum_value.name].join(".")
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

        def path
          [enum.name, old_enum_value.name].join(".")
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

        def path
          [input_type.name, old_field.name].join(".")
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

        def path
          "@#{old_directive.name}"
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

        def path
          [type.name, old_field.name].join(".")
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

        def path
          [type.name, field.name, old_argument.name].join(".")
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

        def path
          ["@#{directive.name}", old_argument.name].join(".")
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

        def path
          [type.name, old_field.name].join(".")
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

        def path
          [object_type.name, field.name].join(".")
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

        def path
          "@#{directive.name}"
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
          @criticality = if argument.type.non_null?
            Changes::Criticality.breaking
          else
            Changes::Criticality.non_breaking
          end
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
