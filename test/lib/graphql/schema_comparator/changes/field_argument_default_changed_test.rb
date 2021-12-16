require "test_helper"

class GraphQL::SchemaComparator::Changes::FieldArgumentDefaultChangedTest < Minitest::Test
  class Type < GraphQL::Schema::Object
    graphql_name "Type"

    field :a, String, null: true do
      argument :a, String, required: false
    end

    field :b, String, null: true do
      argument :a, String, required: false, default_value: "a"
    end

    field :c, String, null: true do
      argument :a, String, required: false, default_value: "b"
    end
  end

  def test_default_value_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentDefaultChanged.new(
      Type,
      Type.fields["a"],
      Type.fields["a"].arguments["a"],
      Type.fields["b"].arguments["a"],
    )

    expected = "Default value `a` was added to argument `a` on field `Type.a`"
    assert_equal expected, change.message
  end

  def test_default_value_changed
    change = GraphQL::SchemaComparator::Changes::FieldArgumentDefaultChanged.new(
      Type,
      Type.fields["a"],
      Type.fields["b"].arguments["a"],
      Type.fields["c"].arguments["a"],
    )

    expected = "Default value for argument `a` on field `Type.a` changed from `a` to `b`"
    assert_equal expected, change.message
  end
end
