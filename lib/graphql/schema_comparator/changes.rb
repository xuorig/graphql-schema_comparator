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
          @criticality = Changes::Criticality.breaking(
            reason: "Removing a type is a breaking change. It is preferable to deprecate and remove all references to this type first."
          )
        end

        def message
          "Type `#{removed_type.graphql_name}` was removed"
        end

        def path
          removed_type.path
        end
      end

      class DirectiveRemoved < AbstractChange
        attr_reader :directive, :criticality

        def initialize(directive)
          @directive = directive
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Directive `#{directive.graphql_name}` was removed"
        end

        def path
          "@#{directive.graphql_name}"
        end
      end

      class TypeKindChanged < AbstractChange
        attr_reader :old_type, :new_type, :criticality

        def initialize(old_type, new_type)
          @old_type = old_type
          @new_type = new_type
          @criticality = Changes::Criticality.breaking(
            reason: "Changing the kind of a type is a breaking change because it can cause existing queries to error. For example, turning an object type to a scalar type would break queries that define a selection set for this type."
          )
        end

        def message
          "`#{old_type.graphql_name}` kind changed from `#{old_type.kind}` to `#{new_type.kind}`"
        end

        def path
          old_type.path
        end
      end

      class EnumValueRemoved < AbstractChange
        attr_reader :enum_value, :enum_type, :criticality

        def initialize(enum_type, enum_value, usage)
          @enum_value = enum_value
          @enum_type = enum_type
          @criticality = if usage.input?
                           Changes::Criticality.breaking(
                             reason: "Removing an enum value will cause existing queries that use this enum value to error."
                           )
                         else
                           Changes::Criticality.non_breaking(
                             reason: "Removing an enum value for enums used only in outputs is non-breaking."
                           )
                         end
        end

        def message
          "Enum value `#{enum_value.graphql_name}` was removed from enum `#{enum_type.graphql_name}`"
        end

        def path
          enum_value.path
        end
      end

      class UnionMemberRemoved < AbstractChange
        attr_reader :union_type, :union_member, :criticality

        def initialize(union_type, union_member)
          @union_member = union_member
          @union_type = union_type
          @criticality = Changes::Criticality.breaking(
            reason: "Removing a union member from a union can cause existing queries that use this union member in a fragment spread to error."
          )
        end

        def message
          "Union member `#{union_member.graphql_name}` was removed from Union type `#{union_type.graphql_name}`"
        end

        def path
          union_type.path
        end
      end

      class InputFieldRemoved < AbstractChange
        attr_reader :input_object_type, :field, :criticality

        def initialize(input_object_type, field)
          @input_object_type = input_object_type
          @field = field
          @criticality = Changes::Criticality.breaking(
            reason: "Removing an input field will cause existing queries that use this input field to error."
          )
        end

        def message
          "Input field `#{field.graphql_name}` was removed from input object type `#{input_object_type.graphql_name}`"
        end

        def path
          field.path
        end
      end

      class FieldArgumentRemoved < AbstractChange
        attr_reader :object_type, :field, :argument, :criticality

        def initialize(object_type, field, argument)
          @object_type = object_type
          @field = field
          @argument = argument
          @criticality = Changes::Criticality.breaking(
            reason: "Removing a field argument is a breaking change because it will cause existing queries that use this argument to error."
          )
        end

        def message
          "Argument `#{argument.graphql_name}: #{argument.type.to_type_signature}` was removed from field `#{object_type.graphql_name}.#{field.graphql_name}`"
        end

        def path
          argument.path
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
          "Argument `#{argument.graphql_name}` was removed from directive `#{directive.graphql_name}`"
        end

        def path
          ["@#{directive.graphql_name}", argument.graphql_name].join('.')
        end
      end

      class RootOperationTypeAdded < AbstractChange
        attr_reader :new_schema, :operation_type, :criticality

        def initialize(new_schema:, operation_type:)
          @new_schema = new_schema
          @operation_type = operation_type
          @criticality = Changes::Criticality.non_breaking(
            reason: "Adding a schema #{operation_type} root is considered non-breaking."
          )
        end

        def message
          "Schema #{operation_type} root `#{operation_type_name}` was added"
        end

        def path
          operation_type_name
        end

        def operation_type_name
          case operation_type
            when :query
              new_schema.query.graphql_name
            when :mutation
              new_schema.mutation.graphql_name
            when :subscription
              new_schema.subscription.graphql_name
          end
        end
      end

      class RootOperationTypeChanged < AbstractChange
        attr_reader :old_schema, :new_schema, :operation_type, :criticality

        def initialize(old_schema:, new_schema:, operation_type:)
          @old_schema = old_schema
          @new_schema = new_schema
          @operation_type = operation_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Schema #{operation_type} root has changed from `#{operation_type_name(old_schema)}` to `#{operation_type_name(new_schema)}`"
        end

        def path
          operation_type_name(old_schema)
        end

        def operation_type_name(schema)
          case operation_type
            when :query
              schema.query.graphql_name
            when :mutation
              schema.mutation.graphql_name
            when :subscription
              schema.subscription.graphql_name
          end
        end
      end

      class RootOperationTypeRemoved < AbstractChange
        attr_reader :old_schema, :operation_type, :criticality

        def initialize(old_schema:, operation_type:)
          @old_schema = old_schema
          @operation_type = operation_type
          @criticality = Changes::Criticality.breaking
        end

        def message
          "Schema #{operation_type} root `#{operation_type_name}` was removed"
        end

        def path
          operation_type_name
        end

        def operation_type_name
          case operation_type
            when :query
              old_schema.query.graphql_name
            when :mutation
              old_schema.mutation.graphql_name
            when :subscription
              old_schema.subscription.graphql_name
          end
        end
      end

      class FieldRemoved < AbstractChange
        attr_reader :object_type, :field, :criticality

        def initialize(object_type, field)
          @object_type = object_type
          @field = field

          if field.deprecation_reason
            @criticality = Changes::Criticality.breaking(
              reason: "Removing a deprecated field is a breaking change. Before removing it, you may want" \
                "to look at the field's usage to see the impact of removing the field."
            )
          else
            @criticality = Changes::Criticality.breaking(
              reason: "Removing a field is a breaking change. It is preferable to deprecate the field before removing it."
            )
          end
        end

        def message
          "Field `#{field.graphql_name}` was removed from object type `#{object_type.graphql_name}`"
        end

        def path
          [object_type.graphql_name, field.graphql_name].join(".")
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
          "Location `#{location}` was removed from directive `#{directive.graphql_name}`"
        end

        def path
          "@#{directive.graphql_name}"
        end
      end

      class ObjectTypeInterfaceRemoved < AbstractChange
        attr_reader :interface, :object_type, :criticality

        def initialize(interface, object_type)
          @interface = interface
          @object_type = object_type
          @criticality = Changes::Criticality.breaking(
            reason: "Removing an interface from an object type can cause existing queries that use this in a fragment spread to error."
          )
        end

        def message
          "`#{object_type.graphql_name}` object type no longer implements `#{interface.graphql_name}` interface"
        end

        def path
          object_type.path
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
          "Field `#{old_field.path}` changed type from `#{old_field.type.to_type_signature}` to `#{new_field.type.to_type_signature}`"
        end

        def criticality
          if safe_change_for_field?(old_field.type, new_field.type)
            Changes::Criticality.non_breaking
          else
            Changes::Criticality.breaking # TODO - Add reason
          end
        end

        def path
          old_field.path
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
            @criticality = Changes::Criticality.breaking(
              reason: "Changing the type of an input field can cause existing queries that use this field to error."
            )
          end

          @input_type = input_type
          @old_input_field = old_input_field
          @new_input_field = new_input_field
        end

        def message
          "Input field `#{path}` changed type from `#{old_input_field.type.to_type_signature}` to `#{new_input_field.type.to_type_signature}`"
        end

        def path
          old_input_field.path
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
            @criticality = Changes::Criticality.breaking(
              reason: "Changing the type of a field's argument can cause existing queries that use this argument to error."
            )
          end

          @type = type
          @field = field
          @old_argument = old_argument
          @new_argument = new_argument
        end

        def message
          "Type for argument `#{new_argument.graphql_name}` on field `#{field.path}` changed"\
            " from `#{old_argument.type.to_type_signature}` to `#{new_argument.type.to_type_signature}`"
        end

        def path
          old_argument.path
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
          "Type for argument `#{new_argument.graphql_name}` on directive `#{directive.graphql_name}` changed"\
            " from `#{old_argument.type.to_type_signature}` to `#{new_argument.type.to_type_signature}`"
        end

        def path
          ["@#{directive.graphql_name}", old_argument.graphql_name].join('.')
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
          if old_argument.default_value?
            "Default value for argument `#{new_argument.graphql_name}` on field `#{field.path}` changed"\
              " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
          else
            "Default value `#{new_argument.default_value}` was added to argument `#{new_argument.graphql_name}` on field `#{field.path}`"
          end
        end

        def path
          old_argument.path
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
          "Input field `#{path}` default changed"\
            " from `#{old_field.default_value}` to `#{new_field.default_value}`"
        end

        def path
          old_field.path
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
          if old_argument.default_value?
            "Default value for argument `#{new_argument.graphql_name}` on directive `#{directive.graphql_name}` changed"\
              " from `#{old_argument.default_value}` to `#{new_argument.default_value}`"
          else
            "Default value `#{new_argument.default_value}` was added to argument `#{new_argument.graphql_name}` on directive `#{directive.graphql_name}`"
          end
        end

        def path
          ["@#{directive.graphql_name}", new_argument.graphql_name].join(".")
        end
      end

      class EnumValueAdded < AbstractChange
        attr_reader :enum_type, :enum_value, :criticality

        def initialize(enum_type, enum_value, usage)
          @enum_type = enum_type
          @enum_value = enum_value
          @criticality = if usage.output?
                           Changes::Criticality.dangerous(
                             reason: "Adding an enum value may break existing clients that were not " \
                              "programmed defensively against an added case when querying an enum."
                           )
                         else
                           Changes::Criticality.non_breaking(
                             reason: "Adding an enum value for enums used only in inputs is non-breaking."
                           )
                         end
        end

        def message
          "Enum value `#{enum_value.graphql_name}` was added to enum `#{enum_type.graphql_name}`"
        end

        def path
          enum_value.path
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
          "Union member `#{union_member.graphql_name}` was added to Union type `#{union_type.graphql_name}`"
        end

        def path
          union_type.path
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
          "`#{object_type.graphql_name}` object implements `#{interface.graphql_name}` interface"
        end

        def path
          object_type.path
        end
      end

      # Mostly Non-Breaking Changes

      class InputFieldAdded < AbstractChange
        attr_reader :input_object_type, :field, :criticality

        def initialize(input_object_type, field)
          @criticality = if field.type.non_null? && !field.default_value?
            Changes::Criticality.breaking(reason: "Adding a non-null input field without a default value to an existing input type will cause existing queries that use this input type to error because they will not provide a value for this new field.")
          else
            Changes::Criticality.non_breaking
          end

          @input_object_type = input_object_type
          @field = field
        end

        def message
          "Input field `#{field.graphql_name}` was added to input object type `#{input_object_type.graphql_name}`"
        end

        def path
          field.path
        end
      end

      class FieldArgumentAdded < AbstractChange
        attr_reader :type, :field, :argument, :criticality

        def initialize(type, field, argument)
          @criticality = if argument.type.non_null? && !argument.default_value?
            Changes::Criticality.breaking(reason: "Adding a required argument without a default value to an existing field is a breaking change because it will cause existing uses of this field to error.")
          else
            Changes::Criticality.non_breaking
          end

          @type = type
          @field = field
          @argument = argument
        end

        def message
          "Argument `#{argument.graphql_name}: #{argument.type.graphql_name}` added to field `#{field.path}`"
        end

        def path
          argument.path
        end
      end

      class TypeAdded < AbstractChange
        attr_reader :type, :criticality

        def initialize(type)
          @type = type
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Type `#{type.graphql_name}` was added"
        end

        def path
          type.path
        end
      end

      class DirectiveAdded < AbstractChange
        attr_reader :directive, :criticality

        def initialize(directive)
          @directive = directive
          @criticality = Changes::Criticality.non_breaking
        end

        def message
          "Directive `#{directive.graphql_name}` was added"
        end

        def path
          "@#{directive.graphql_name}"
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
          "Description `#{old_type.description}` on type `#{old_type.graphql_name}` has changed to `#{new_type.description}`"
        end

        def path
          old_type.path
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
          "Description for enum value `#{new_enum_value.path}` changed from " \
            "`#{old_enum_value.description}` to `#{new_enum_value.description}`"
        end

        def path
          old_enum_value.path
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
            "Enum value `#{new_enum_value.path}` deprecation reason changed " \
              "from `#{old_enum_value.deprecation_reason}` to `#{new_enum_value.deprecation_reason}`"
          else
            "Enum value `#{new_enum_value.path}` was deprecated with reason `#{new_enum_value.deprecation_reason}`"
          end
        end

        def path
          old_enum_value.path
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
          "Input field `#{old_field.path}` description changed"\
            " from `#{old_field.description}` to `#{new_field.description}`"
        end

        def path
          old_field.path
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
          "Directive `#{new_directive.graphql_name}` description changed"\
            " from `#{old_directive.description}` to `#{new_directive.description}`"
        end

        def path
          "@#{old_directive.graphql_name}"
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
          "Field `#{old_field.path}` description changed"\
            " from `#{old_field.description}` to `#{new_field.description}`"
        end

        def path
          old_field.path
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
          "Description for argument `#{new_argument.graphql_name}` on field `#{field.path}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end

        def path
          old_argument.path
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
          "Description for argument `#{new_argument.graphql_name}` on directive `#{directive.graphql_name}` changed"\
            " from `#{old_argument.description}` to `#{new_argument.description}`"
        end

        def path
          ["@#{directive.graphql_name}", old_argument.graphql_name].join(".")
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
          "Deprecation reason on field `#{new_field.path}` has changed "\
            "from `#{old_field.deprecation_reason}` to `#{new_field.deprecation_reason}`"
        end

        def path
          old_field.path
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
          "Field `#{field.graphql_name}` was added to object type `#{object_type.graphql_name}`"
        end

        def path
          [object_type.graphql_name, field.graphql_name].join(".")
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
          "Location `#{location}` was added to directive `#{directive.graphql_name}`"
        end

        def path
          "@#{directive.graphql_name}"
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
          "Argument `#{argument.graphql_name}` was added to directive `#{directive.graphql_name}`"
        end

        def path
          ["@#{directive.graphql_name}", argument.graphql_name].join('.')
        end
      end
    end
  end
end
