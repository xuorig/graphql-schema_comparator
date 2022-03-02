require "test_helper"

class GraphQL::SchemaComparator::Changes::FieldArgumentRemovedTest < Minitest::Test
  class Type < GraphQL::Schema::Object
    graphql_name "Type"

    field :field, String, null: true do
      argument :nullable, String, required: false
      argument :non_null, String, required: true
      argument :non_null_with_default, String, required: true, default_value: "bar"
    end
  end

  def test_nullable_removed
    change = GraphQL::SchemaComparator::Changes::FieldArgumentRemoved.new(
      Type,
      Type.fields["field"],
      Type.fields["field"].arguments["nullable"],
    )

    assert change.breaking?
    assert_equal change.message, "Argument `nullable: String` was removed from field `Type.field`"
  end

  def test_non_null_removed
    change = GraphQL::SchemaComparator::Changes::FieldArgumentRemoved.new(
      Type,
      Type.fields["field"],
      Type.fields["field"].arguments["nonNull"],
    )

    assert change.breaking?
    assert_equal change.message, "Argument `nonNull: String!` was removed from field `Type.field`"
  end
end
