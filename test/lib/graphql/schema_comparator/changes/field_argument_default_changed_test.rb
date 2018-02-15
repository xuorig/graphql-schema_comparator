require "test_helper"

class GraphQL::SchemaComparator::Changes::FieldArgumentDefaultChangedTest < Minitest::Test
  def setup
    @type = GraphQL::ObjectType.define do
      name "Type"
    end

    @field_a = GraphQL::Field.define do
      name "a"
      argument :a, GraphQL::STRING_TYPE
    end

    @field_b = GraphQL::Field.define do
      name "a"
      argument :a, GraphQL::STRING_TYPE, default_value: "a"
    end

    @field_c = GraphQL::Field.define do
      name "a"
      argument :a, GraphQL::STRING_TYPE, default_value: "b"
    end
  end

  def test_default_value_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentDefaultChanged.new(
      @type,
      @field_a,
      @field_a.arguments["a"],
      @field_b.arguments["a"],
    )

    expected = "Default value `a` was added to argument `a` on field `Type.a`"
    assert_equal expected, change.message
  end

  def test_default_value_changed
    change = GraphQL::SchemaComparator::Changes::FieldArgumentDefaultChanged.new(
      @type,
      @field_a,
      @field_b.arguments["a"],
      @field_c.arguments["a"],
    )

    expected = "Default value for argument `a` on field `Type.a` changed from `a` to `b`"
    assert_equal expected, change.message
  end
end
