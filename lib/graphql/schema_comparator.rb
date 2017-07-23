require "graphql"
require "graphql/schema_comparator/version"
require "graphql/schema_comparator/diff/schema"
require "graphql/schema_comparator/changes"
require "graphql/schema_comparator/result"

module GraphQL
  module SchemaComparator
    def self.compare(old_schema, new_schema)
      parsed_old = parse_schema(old_schema)
      parsed_new = parse_schema(new_schema)

      changes = Diff::Schema.new(parsed_old, parsed_new).diff
      Result.new(changes)
    end

    private

    def self.parse_schema(schema)
      if schema.is_a?(GraphQL::Schema)
        schema
      elsif schema.is_a?(String)
        GraphQL::Schema.from_definition(schema)
      else
        raise ArgumentError, "Invalid Schema #{schema}. Expected a valid IDL or GraphQL::Schema object."
      end
    end
  end
end
