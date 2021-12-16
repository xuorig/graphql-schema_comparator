require "test_helper"

class GraphQL::SchemaComparator::Changes::InputFieldAddedTest < Minitest::Test
  class Type < GraphQL::Schema::InputObject
    graphql_name "Input"

    argument :nullable, String, required: false
    argument :non_null, String, required: true
    argument :non_null_with_default, String, required: true, default_value: "bar"
  end

  def test_nullable_added
    change = GraphQL::SchemaComparator::Changes::InputFieldAdded.new(
      Type,
      Type.arguments["nullable"],
    )

    assert change.non_breaking?
  end

  def test_non_null_added
    change = GraphQL::SchemaComparator::Changes::InputFieldAdded.new(
      Type,
      Type.arguments["nonNull"],
    )

    assert change.breaking?
  end

  def test_non_null_with_default_added
    change = GraphQL::SchemaComparator::Changes::InputFieldAdded.new(
      Type,
      Type.arguments["nonNullWithDefault"],
    )

    assert change.non_breaking?
  end
end
