require "test_helper"

class GraphQL::SchemaComparatorTest < Minitest::Test
  def setup
    @old_schema_idl = <<~SCHEMA
      schema {
        query: Query
      }
      type Query {
        a: String!
      }
    SCHEMA

    @new_schema_idl = <<~SCHEMA
      schema {
        query: Query
      }
      type Query {
        a: Int
        b: Int!
      }
    SCHEMA
  end

  def test_compare_handles_idls
    result = GraphQL::SchemaComparator.compare(@old_schema_idl, @new_schema_idl)

    assert_equal [
      "Field `Query.a` changed type from `String!` to `Int`",
      "Field `b` was added to object type `Query`",
    ], result.changes.map(&:message)

    assert_equal true, result.breaking?
  end

  def test_compare_handles_schema_objects
    old_schema = GraphQL::Schema.from_definition(@old_schema_idl)
    new_schema = GraphQL::Schema.from_definition(@new_schema_idl)
    result = GraphQL::SchemaComparator.compare(old_schema, new_schema)

    assert_equal [
      "Field `Query.a` changed type from `String!` to `Int`",
      "Field `b` was added to object type `Query`",
    ], result.changes.map(&:message)

    assert_equal true, result.breaking?
  end
end
