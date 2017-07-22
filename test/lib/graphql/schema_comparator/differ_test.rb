require "test_helper"

describe GraphQL::SchemaComparator::Differ do
  let(:old_schema) do
    GraphQL::Schema.from_definition(
      <<~SCHEMA
        schema {
          query: Query
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
      SCHEMA
    )
  end

  let(:new_schema) do
    GraphQL::Schema.from_definition(
      <<~SCHEMA
        schema {
          query: Query
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
      SCHEMA
    )
  end

  let(:differ) { GraphQL::SchemaComparator::Differ.new(old_schema, new_schema) }

  describe "#changes" do
    it "returns a list of changes between schema" do
      assert_equal [
        "Description `The Query Root of this schema` on type `Query` has changed to `Query Root description changed`",
        "BType's kind has changed from `OBJECT` to `INPUT_OBJECT`",
      ], differ.changes.map(&:message)
    end
  end
end
