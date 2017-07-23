require "test_helper"

describe GraphQL::SchemaComparator::Result do
  describe "#identical?" do
    it "returns false when schemas have changes" do
      result = GraphQL::SchemaComparator::Result.new([
        GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
      ])
      assert_equal false, result.identical?
    end

    it "returns true when schemas are the same" do
      result = GraphQL::SchemaComparator::Result.new([])
      assert_equal true, result.identical?
    end
  end

  describe "#breaking?" do
    it "returns true when changes include at least one breaking change" do
      result = GraphQL::SchemaComparator::Result.new([
        GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
      ])
      assert_equal true, result.breaking?
    end

    it "returns false when changes include no breaking changes" do
      result = GraphQL::SchemaComparator::Result.new([
        GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.new, GraphQL::Field.new)
      ])
      assert_equal false, result.breaking?
    end
  end

  describe "#breaking_changes" do
    let(:field_added) {
      GraphQL::SchemaComparator::Changes::FieldAdded.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    }

    let(:field_removed) {
      GraphQL::SchemaComparator::Changes::FieldRemoved.new(GraphQL::ObjectType.new, GraphQL::Field.new)
    }

    let(:type_description_changed) {
      GraphQL::SchemaComparator::Changes::TypeDescriptionChanged.new(GraphQL::ObjectType.new, GraphQL::ObjectType.new)
    }

    it "returns only breaking changes from the result" do
      result = GraphQL::SchemaComparator::Result.new([
        field_added,
        field_removed,
        type_description_changed
      ])

      assert_equal [field_removed], result.breaking_changes
    end
  end
end
