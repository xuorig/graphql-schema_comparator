require "test_helper"

describe GraphQL::SchemaComparator do
  describe ".compare" do
    let(:old_schema_idl) do
      <<~SCHEMA
        schema {
          query: Query
        }
        type Query {
          a: String!
        }
      SCHEMA
    end

    let(:new_schema_idl) do
      <<~SCHEMA
        schema {
          query: Query
        }
        type Query {
          a: Int
          b: Int!
        }
      SCHEMA
    end

    let(:old_schema) { GraphQL::Schema.from_definition(old_schema_idl) }
    let(:new_schema) { GraphQL::Schema.from_definition(new_schema_idl) }

    it "returns a Result object containing schema changes" do

    end

    it "handles IDL" do
      result = GraphQL::SchemaComparator.compare(old_schema_idl, new_schema_idl)

      assert_equal [
        "Field `b` was added to object type `Query`",
        "Field `Query.a` changed type from `String!` to `Int`"
      ], result.changes.map(&:message)

      assert_equal true, result.breaking?
    end

    it "handles GraphQL::Schema objects" do
      result = GraphQL::SchemaComparator.compare(old_schema, new_schema)

      assert_equal [
        "Field `b` was added to object type `Query`",
        "Field `Query.a` changed type from `String!` to `Int`"
      ], result.changes.map(&:message)

      assert_equal true, result.breaking?
    end
   end
end
