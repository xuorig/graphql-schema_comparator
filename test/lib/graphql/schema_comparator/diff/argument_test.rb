require "test_helper"

class GraphQL::SchemaComparator::Diff::ArgumentTest < Minitest::Test
  class Type < GraphQL::Schema::Object
    graphql_name "Query"

    field :a, String, null: true
  end

  Field = Type.fields["a"]

  def test_diff_input_field_type_change
    old_input_field = Field.argument(:foo, "String", required: false)
    new_input_field = Field.argument(:foo, "Boolean", required: false)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `foo` on field `Query.a` changed from `String` to `Boolean`", change.message
  end

  def test_diff_input_field_type_change_from_scalar_to_list_of_the_same_type
    old_input_field = Field.argument(:arg, "[String]", required: false)
    new_input_field = Field.argument(:arg, "String", required: false)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_non_null_to_null_same_type
    old_input_field = Field.argument(:arg, "String", required: true)
    new_input_field = Field.argument(:arg, "String", required: false)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `String!` to `String`", change.message
  end

  def test_diff_input_field_type_change_from_null_to_non_null_of_same_type
    old_input_field = Field.argument(:arg, "String", required: false)
    new_input_field = Field.argument(:arg, "String", required: true)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `String` to `String!`", change.message
  end

  def test_diff_input_field_type_nullability_change_on_lists_of_the_same_underlying_types
    old_input_field = Field.argument(:arg, "[String]", required: true)
    new_input_field = Field.argument(:arg, "[String]", required: false)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String!]`", change.message
  end

  def test_diff_input_field_type_change_within_lists_of_the_same_underlying_types
    old_input_field = Field.argument(:arg, ["String"], required: true)
    new_input_field = Field.argument(:arg, ["String", null: true], required: true)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String]!`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_the_same_underlying_types
    old_input_field = Field.argument(:arg, ["String"], required: true)
    new_input_field = Field.argument(:arg, ["String", null: true], required: false)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[String]`", change.message
  end

  def test_input_field_type_changes_on_and_within_lists_of_different_underlying_types
    old_input_field = Field.argument(:arg, ["String"], required: true)
    new_input_field = Field.argument(:arg, ["Boolean", null: true], required: false)

    differ = GraphQL::SchemaComparator::Diff::Argument.new(Type, Field, old_input_field, new_input_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Type for argument `arg` on field `Query.a` changed from `[String!]!` to `[Boolean]`", change.message
  end
end
