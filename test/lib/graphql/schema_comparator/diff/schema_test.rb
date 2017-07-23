require "test_helper"

describe GraphQL::SchemaComparator::Diff::Schema do
  let(:old_schema) do
    GraphQL::Schema.from_definition(
      <<~SCHEMA
        schema {
          query: Query
        }
        input AInput {
          # a
          a: String = "1"
          b: String!
        }
        # The Query Root of this schema
        type Query {
          # Just a simple string
          a: String!
          b: BType
        }
        type BType {
          a: String
        }
        type CType {
          a: String
        }
        union MyUnion = CType | BType
      SCHEMA
    )
  end

  let(:new_schema) do
    GraphQL::Schema.from_definition(
      <<~SCHEMA
        schema {
          query: Query
        }
        input AInput {
          # changed
          a: Int = 1
          c: String!
        }
        # Query Root description changed
        type Query {
          # This description has been changed
          a: String!
          b: Int!
        }
        input BType {
          a: String!
        }
        type CType {
          a: String
        }
        type DType {
          b: Int!
        }
        union MyUnion = CType | DType
      SCHEMA
    )
  end

  let(:differ) { GraphQL::SchemaComparator::Diff::Schema.new(old_schema, new_schema) }

  describe "#changes" do
    it "returns a list of changes between schemas" do
      assert_equal [
        "`DType` was added",
        "Description `The Query Root of this schema` on type `Query` has changed to `Query Root description changed`",
        "`BType` kind changed from `OBJECT` to `INPUT_OBJECT`",
        "Input field `b` was removed from input object type `AInput`",
        "Input field `c` was added to input object type `AInput`",
        "Input field `AInput.a` description changed from `a` to `changed`",
        "Input field `AInput.a` default changed from `1` to `1`",
        "Input field `AInput.a` changed type from String to Int",
        "Union member `BType` was removed from Union type `MyUnion`",
        "Union member `DType` was added to Union type `MyUnion`",
      ], differ.diff.map(&:message)
    end
  end
end
