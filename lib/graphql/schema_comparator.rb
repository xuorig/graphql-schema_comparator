require "graphql"

require "graphql/schema_comparator/version"
require "graphql/schema_comparator/result"

require 'graphql/schema_comparator/changes'
require 'graphql/schema_comparator/enum_usage'

require "graphql/schema_comparator/diff/schema"
require "graphql/schema_comparator/diff/argument"
require "graphql/schema_comparator/diff/directive"
require "graphql/schema_comparator/diff/directive_argument"
require "graphql/schema_comparator/diff/enum"
require "graphql/schema_comparator/diff/field"
require "graphql/schema_comparator/diff/input_object"
require "graphql/schema_comparator/diff/input_field"
require "graphql/schema_comparator/diff/object_type"
require "graphql/schema_comparator/diff/interface"
require "graphql/schema_comparator/diff/union"

module GraphQL
  module SchemaComparator
    # Compares and returns changes for two versions of a schema
    #
    # @param old_schema [GraphQL::Schema, String]
    # @param new_schema [GraphQL::Schema, String]
    # @return [GraphQL::SchemaComparator::Result] the result of the comparison
    def self.compare(old_schema, new_schema)
      parsed_old = parse_schema(old_schema)
      parsed_new = parse_schema(new_schema)

      changes = Diff::Schema.new(parsed_old, parsed_new).diff
      Result.new(changes)
    end

    private

    def self.parse_schema(schema)
      if schema.respond_to?(:ancestors) && schema.ancestors.include?(GraphQL::Schema)
        schema
      elsif schema.is_a?(String)
        GraphQL::Schema.from_definition(schema)
      else
        raise ArgumentError, "Invalid Schema #{schema}. Expected a valid IDL or GraphQL::Schema object."
      end
    end
  end
end
