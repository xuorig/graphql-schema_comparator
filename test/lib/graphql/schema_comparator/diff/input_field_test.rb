require "test_helper"

class GraphQL::SchemaComparator::Diff::InputFieldTest < Minitest::Test
  def setup
    @type = GraphQL::InputObjectType.define do
      name "Input"
    end
  end

  def test_diff_input_field_type_change
    old_input_field = GraphQL::Argument.define do
      name "foo"
      type types.String
    end

    new_input_field = old_input_field.redefine { type types.Boolean }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.foo` changed type from `String` to `Boolean`", change.message
  end

  def test_diff_input_field_type_change_from_scalar_to_list_of_the_same_type
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type types[types.String]
    end

    new_input_field = old_input_field.redefine { type types.String }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String]` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_non_null_to_null_same_type
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types.String
    end

    new_input_field = old_input_field.redefine { type types.String }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `String!` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_null_to_non_null_of_same_type
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type types.String
    end

    new_input_field = old_input_field.redefine { type !types.String }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `String` to `String!`", change.message
  end

  def test_diff_input_field_type_nullability_change_on_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[types.String]
    end

    new_input_field = old_input_field.redefine { type types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String]!` to `[String]`", change.message
  end

  def test_diff_input_field_type_change_within_lists_of_the_same_underyling_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[!types.String]
    end

    new_input_field = old_input_field.redefine { type !types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[String]!`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[!types.String]
    end

    new_input_field = old_input_field.redefine { type types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[String]`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_different_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[!types.String]
    end

    new_input_field = old_input_field.redefine { type types[types.Boolean] }

    differ = GraphQL::SchemaComparator::Diff::InputField.new(@type, @type, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[Boolean]`", change.message
  end
end
