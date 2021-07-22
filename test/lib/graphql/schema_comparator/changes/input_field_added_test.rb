require "test_helper"

class GraphQL::SchemaComparator::Changes::InputFieldAddedTest < Minitest::Test
  def setup
    @input_type = GraphQL::InputObjectType.define do
      name "Input"
    end

    @nullable_input_field = GraphQL::Argument.define do
      name "foo"
      type GraphQL::STRING_TYPE
    end

    @non_null_input_field = GraphQL::Argument.define do
      name "foo"
      type !GraphQL::STRING_TYPE
    end

    @non_null_input_field_with_default = GraphQL::Argument.define do
      name "foo"
      type !GraphQL::STRING_TYPE
      default_value "bar"
    end
  end

  def test_nullable_added
    change = GraphQL::SchemaComparator::Changes::InputFieldAdded.new(
      @input_type,
      @nullable_input_field
    )

    assert change.non_breaking?
  end

  def test_non_null_added
    change = GraphQL::SchemaComparator::Changes::InputFieldAdded.new(
      @input_type,
      @non_null_input_field
    )

    assert change.breaking?
  end

  def test_non_null_with_default_added
    change = GraphQL::SchemaComparator::Changes::InputFieldAdded.new(
      @input_type,
      @non_null_input_field_with_default
    )

    assert change.non_breaking?
  end
end
