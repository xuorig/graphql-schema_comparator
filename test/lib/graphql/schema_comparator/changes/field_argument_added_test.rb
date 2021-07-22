require "test_helper"

class GraphQL::SchemaComparator::Changes::FieldArgumentAddedTest < Minitest::Test
  def setup
    @type = GraphQL::ObjectType.define do
      name "Type"
    end

    @field = GraphQL::Field.define do
      name "field"
    end

    @nullable_argument = GraphQL::Argument.define do
      name "foo"
      type GraphQL::STRING_TYPE
    end

    @non_null_argument = GraphQL::Argument.define do
      name "foo"
      type !GraphQL::STRING_TYPE
    end

    @non_null_argument_with_default = GraphQL::Argument.define do
      name "foo"
      type !GraphQL::STRING_TYPE
      default_value "bar"
    end
  end

  def test_nullable_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentAdded.new(
      @type,
      @field,
      @nullable_argument
    )

    assert change.non_breaking?
  end

  def test_non_null_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentAdded.new(
      @type,
      @field,
      @non_null_argument
    )

    assert change.breaking?
  end

  def test_non_null_with_default_added
    change = GraphQL::SchemaComparator::Changes::FieldArgumentAdded.new(
      @type,
      @field,
      @non_null_argument_with_default
    )

    assert change.non_breaking?
  end
end
