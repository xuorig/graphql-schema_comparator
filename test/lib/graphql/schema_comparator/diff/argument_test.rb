require "test_helper"

class GraphQL::SchemaComparator::Diff::ArgumentTest < Minitest::Test
  def setup
    @type = GraphQL::ObjectType.define do
      name "Query"
      field :a, types.String
    end

    @field = @type.fields["a"]
  end

  def test_diff_input_field_type_change
    old_input_field = GraphQL::Argument.define do
      name "foo"
      type types.String
    end

    new_input_field = old_input_field.redefine { type types.Boolean }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `foo` on field `Query.a` changed from `String` to `Boolean`", change.message
  end

  def test_diff_input_field_type_change_from_scalar_to_list_of_the_same_type
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type types[types.String]
    end

    new_input_field = old_input_field.redefine { type types.String }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String]` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_non_null_to_null_same_type
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types.String
    end

    new_input_field = old_input_field.redefine { type types.String }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `String!` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_null_to_non_null_of_same_type
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type types.String
    end

    new_input_field = old_input_field.redefine { type !types.String }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `String` to `String!`", change.message
  end

  def test_diff_input_field_type_nullability_change_on_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[types.String]
    end

    new_input_field = old_input_field.redefine { type types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String]!` to `[String]`", change.message
  end

  def test_diff_input_field_type_change_within_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[!types.String]
    end

    new_input_field = old_input_field.redefine { type !types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String]!`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_the_same_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[!types.String]
    end

    new_input_field = old_input_field.redefine { type types[types.String] }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String]`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_different_underlying_types
    old_input_field = GraphQL::Argument.define do
      name "arg"
      type !types[!types.String]
    end

    new_input_field = old_input_field.redefine { type types[types.Boolean] }

    differ = GraphQL::SchemaComparator::Diff::Argument.new(@type, @field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[Boolean]`", change.message
  end
end
