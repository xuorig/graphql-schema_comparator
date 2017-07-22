require "test_helper"

describe GraphQL::SchemaComparator do
  describe ".compare" do
    let(:old_schema) do
      <<~SCHEMA
        schema {
          query: Query
        }
        type Query {
          a: String!
        }
      SCHEMA
    end

    let(:new_schema) do
      <<~SCHEMA
        schema {
          query: Query
        }
        type Query {
          a: String!
          b: Int!
        }
      SCHEMA
    end

    it "returns a list of GraphQL schema changes" do
      changes = GraphQL::SchemaComparator.compare(old_schema, new_schema)
    end
  end
end
