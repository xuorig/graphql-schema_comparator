require "test_helper"

class GraphQL::SchemaComparator::Diff::FieldTest < Minitest::Test
  class Type < GraphQL::Schema::Object
    graphql_name "Foo"
  end

  def test_field_type_change
    old_field = Type.field(:bar, "String", null: true)
    new_field = Type.field(:bar, "Boolean", null: true)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `String` to `Boolean`", change.message
  end

  def test_field_type_change_from_scalar_to_list_of_the_same_type
    old_field = Type.field(:bar, ["String", null: true], null: true)
    new_field = Type.field(:bar, "String", null: true)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String]` to `String`", change.message
  end

  def test_field_type_change_from_non_null_to_null_of_the_same_type
    old_field = Type.field(:bar, "String", null: false)
    new_field = Type.field(:bar, "String", null: true)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `String!` to `String`", change.message
  end

  def test_field_type_change_from_null_to_non_null_of_the_same_type
    old_field = Type.field(:bar, "String", null: true)
    new_field = Type.field(:bar, "String", null: false)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    refute change.breaking?

    assert_equal "Field `Foo.bar` changed type from `String` to `String!`", change.message
  end

  def test_field_type_change_nullability_change_on_lists_of_same_type
    old_field = Type.field(:bar, ["String", null: true], null: false)
    new_field = Type.field(:bar, ["String", null: true], null: true)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String]!` to `[String]`", change.message
  end

  def test_field_type_change_within_lists_of_the_same_underlying_types
    old_field = Type.field(:bar, ["String"], null: false)
    new_field = Type.field(:bar, ["String", null: true], null: false)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[String]!`", change.message
  end

  def test_field_type_change_within_and_on_list_of_same_type
    old_field = Type.field(:bar, ["String"], null: false)
    new_field = Type.field(:bar, ["String", null: true], null: true)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[String]`", change.message
  end

  def test_field_type_change_within_and_on_list_of_same_type_of_different_types
    old_field = Type.field(:bar, ["String"], null: false)
    new_field = Type.field(:bar, ["Boolean", null: true], null: true)

    differ = GraphQL::SchemaComparator::Diff::Field.new(Type, Type, old_field, new_field)
    changes = differ.diff
    change = differ.diff.first

    assert_equal 1, changes.size
    assert change.breaking?

    assert_equal "Field `Foo.bar` changed type from `[String!]!` to `[Boolean]`", change.message
  end
end
