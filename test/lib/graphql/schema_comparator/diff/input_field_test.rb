require "test_helper"

class GraphQL::SchemaComparator::Diff::InputFieldTest < Minitest::Test
  class Input < GraphQL::Schema::InputObject
    graphql_name "Input"
  end

  def test_diff_input_field_type_change
    old_input_field = GraphQL::Schema::Argument.new(:arg, "String", required: false, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, "Boolean", required: false, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `String` to `Boolean`", change.message
  end

  def test_diff_input_field_type_change_from_scalar_to_list_of_the_same_type
    old_input_field = GraphQL::Schema::Argument.new(:arg, ["String", null: true], required: false, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, "String", required: false, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String]` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_non_null_to_null_same_type
    old_input_field = GraphQL::Schema::Argument.new(:arg, "String", required: true, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, "String", required: false, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `String!` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_null_to_non_null_of_same_type
    old_input_field = GraphQL::Schema::Argument.new(:arg, "String", required: false, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, "String", required: true, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `String` to `String!`", change.message
  end

  def test_diff_input_field_type_nullability_change_on_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Schema::Argument.new(:arg, ["String", null: true], required: true, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, ["String", null: true], required: false, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String]!` to `[String]`", change.message
  end

  def test_diff_input_field_type_change_within_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Schema::Argument.new(:arg, ["String"], required: true, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, ["String", null: true], required: true, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[String]!`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Schema::Argument.new(:arg, ["String"], required: true, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, ["String", null: true], required: false, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[String]`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_different_underlying_types
    old_input_field = GraphQL::Schema::Argument.new(:arg, ["String"], required: true, owner: Input)
    new_input_field = GraphQL::Schema::Argument.new(:arg, ["Boolean", null: true], required: false, owner: Input)

    differ = GraphQL::SchemaComparator::Diff::InputField.new(Input, Input, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Input field `Input.arg` changed type from `[String!]!` to `[Boolean]`", change.message
  end
end
