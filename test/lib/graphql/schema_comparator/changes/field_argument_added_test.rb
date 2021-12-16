require "test_helper"

class GraphQL::SchemaComparator::Changes::FieldArgumentAddedTest < Minitest::Test
  class Type < GraphQL::Schema::Object
    graphql_name "Type"

    field :field, String, null: true do
      argument :nullable, String, required: false
      argument :non_null, String, required: true
      argument :non_null_with_default, String, required: true, default_value: "bar"
    end
  end

  def test_nullable_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentAdded.new(
      Type,
      Type.fields["field"],
      Type.fields["field"].arguments["nullable"],
    )

    assert change.non_breaking?
  end

  def test_non_null_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentAdded.new(
      Type,
      Type.fields["field"],
      Type.fields["field"].arguments["nonNull"],
    )

    assert change.breaking?
  end

  def test_non_null_with_default_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentAdded.new(
      Type,
      Type.fields["field"],
      Type.fields["field"].arguments["nonNullWithDefault"],
    )

    assert change.non_breaking?
  end
end
